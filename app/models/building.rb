# frozen_string_literal: true

# Rails model for buildings. Census records are attached to buildings. They also have photos and some
# metadata originally designed and provided by Historic Ithaca.
class Building < ApplicationRecord
  include AutoStripAttributes
  include Moderation
  include DefineEnumeration
  include Flaggable
  include Versioning

  has_rich_text :description

  define_enumeration :address_street_prefix, %w[N S E W]
  define_enumeration :address_street_suffix, %w[St Rd Ave Blvd Pl Terr Jct Pt Tpke Ct Pk Tr Dr Hill Cir Sq Ln Fwy Hwy Way].sort
  # From Postal Service
  # %w[Aly Anx Arc Ave Byu Bch Bch Bnd Blf Blfs Btn Br Brg Brk Brks Bg Bgs Byp Cp Cyn Cpe Cswy Ctr Ctrs Cir Cirs Clf Clfs Clb Cmn Cmns Cor Cors Crse Cts Cv Cvs Crk Cres Crst Xing Xrd Xrds Curv Dl Dm Dv Drs Est Ests Expyn ExtFall Fls Fry Fld Flds Flt Flts Frd Frds Frst Frg Frgs Frk Frks Ft Fwy Gdn Gdns Gtwy Gln Glns Grn Grns Grv Grvs Hbr Hbrs Hvn Hts Hwy Hl Hls How Inlt Is Iss Isle Jct Jcts Ky Kys Knl Knls Lk Lks Land Lndg Lgt Lgts Lf Lck Lcks Ldg Loop Mnr Mnrs Mdw Mdws Mew Ml Mls Msn Mtwy Mt Mtn Mtns Nck Orch Oval Opas Park Pkwy Pass Psge Path Pike Pne Pnes Pl Pln Plns Plz Pt Pts Prt Pr Radl Ramp Rnch Rpd Rpds Rst Rdg Rdgs Riv Rds Rte Row Rue Run Shl Shls Skwy Spg Spgs Spur Sq Sqs Sta Stra Strm Sts Smt Trwy Trce Trak Trfy Trl Trlr Tunl Tpke Upas Un Uns Vly Vlys Via Vw Vws Vlg Vlgs Vl Vis Walk Wl Wls].sort


  belongs_to :locality, optional: true

  has_many :addresses, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: proc { |p| p['name'].blank? }

  has_and_belongs_to_many :architects

  CensusYears.each do |year|
    has_many :"census_#{year}_records", dependent: :nullify, class_name: "Census#{year}Record"
  end

  has_and_belongs_to_many :photos, class_name: 'Photograph', dependent: :nullify

  before_validation :check_locality

  validates :name, presence: true, length: { maximum: 255 }
  validates :year_earliest, :year_latest, numericality: { minimum: 1500, maximum: 2100, allow_nil: true }
  validate :validate_primary_address

  delegate :name, to: :frame_type, prefix: true, allow_nil: true
  delegate :name, to: :lining_type, prefix: true, allow_nil: true

  scope :as_of_year, lambda { |year|
    where('(year_earliest is null and year_latest is null) or (year_earliest<=:year and (year_latest is null or year_latest>=:year)) or (year_earliest is null and year_latest>=:year)', year: year)
  }

  scope :as_of_year_eq, lambda { |year|
    where('(year_earliest<=:year and (year_latest is null or year_latest>=:year)) or (year_earliest is null and year_latest>=:year)', year: year)
  }

  scope :without_residents, lambda {
    joins('LEFT OUTER JOIN census_1900_records ON census_1900_records.building_id=buildings.id')
      .joins('LEFT OUTER JOIN census_1910_records ON census_1910_records.building_id=buildings.id')
      .joins('LEFT OUTER JOIN census_1920_records ON census_1920_records.building_id=buildings.id')
      .joins('LEFT OUTER JOIN census_1930_records ON census_1930_records.building_id=buildings.id')
      .joins('LEFT OUTER JOIN census_1940_records ON census_1940_records.building_id=buildings.id')
      .where('census_1900_records.id IS NULL AND census_1910_records.id IS NULL AND census_1920_records.id IS NULL AND census_1930_records.id IS NULL AND census_1940_records.id IS NULL')
      .where(building_types: { name: 'residence' }) }

  scope :by_street_address, lambda {
    left_outer_joins(:addresses)
      .order('addresses.name asc, addresses.prefix asc, addresses.house_number asc')
  }

  scope :building_types_id_in, lambda { |*ids|
    if ids.empty?
      where("building_types_mask > 0")
    else
      where 'building_types_mask & ? > 0', BuildingType.mask_for(ids)
    end
  }

  scope :building_types_id_not_in, lambda { |*ids|
    if ids.empty?
      where("building_types_mask = 0")
    else
      where.not 'building_types_mask & ? > 0', BuildingType.mask_for(ids)
    end
  }

  scope :building_types_id_null, -> { where(building_types_mask: nil) }
  scope :building_types_id_not_null, -> { where.not(building_types_mask: nil) }

  def self.ransackable_scopes(_auth_object=nil)
    %i[as_of_year without_residents as_of_year_eq
     building_types_id_in building_types_id_not_in building_types_id_null building_types_id_not_null]
  end

  Geocoder.configure(
    timeout: 2,
    use_https: true,
    lookup: :google,
    api_key: AppConfig.geocoding_key
  )

  geocoded_by :full_street_address, latitude: :lat, longitude: :lon
  after_validation :do_the_geocode, if: :new_record?

  ransacker :street_address, formatter: proc { |v| v.mb_chars.downcase.to_s } do
    addresses = Address.arel_table
    Arel::Nodes::NamedFunction.new('LOWER',
                                   [Arel::Nodes::NamedFunction.new('concat_ws',
                                                                   [Arel::Nodes::Quoted.new(' '),
                                                                    addresses[:house_number],
                                                                    addresses[:prefix],
                                                                    addresses[:name],
                                                                    addresses[:suffix]
                                                                   ])])
  end

  auto_strip_attributes :name, :stories

  alias_attribute :latitude, :lat
  alias_attribute :longitude, :lon

  def proper_name?
    name && (address_house_number.blank? || !name.include?(address_house_number))
  end

  def do_the_geocode
    return if Rails.env.test?

    geocode
  rescue Errno::ENETUNREACH
    nil
  end

  # TODO: this presentation stuff overlaps with the BuildingPresenter. Make the Buildings::MainController use the presenter.
  def full_street_address
    "#{[street_address, city, state].join(' ')} #{postal_code}"
  end

  def architects_list
    architects.map(&:name).join(', ')
  end

  def architects_list=(value)
    self.architects = value.split(',').map(&:strip).map { |item| Architect.find_or_create_by(name: item) }
  end

  def address
    return @address if defined?(@address)

    @address = addresses&.detect(&:is_primary)
  end

  def address_house_number
    address&.house_number
  end

  def address_street_prefix
    address&.prefix
  end

  def address_street_name
    address&.name
  end

  def address_street_suffix
    address&.suffix
  end

  def city
    address&.city
  end

  def street_address_for_building_id
    base = addresses.sort_by { |b| b.is_primary? ? -1 : 1 }.map(&:address)
    base << name if proper_name?
    base.join(', ')
  end

  def street_address
    addresses.sort_by { |b| b.is_primary? ? -1 : 1 }.map(&:address).join("\n")
  end

  def primary_street_address
    (addresses.detect(&:is_primary) || addresses.first || OpenStruct.new(address: 'No address')).address
  end

  def ensure_primary_address
    addresses.build(is_primary: true) if new_record? && addresses.blank?
  end

  def name_the_house
    return if name.present?

    self.name = primary_street_address
  end
  before_validation :name_the_house

  def neighbors
    lat? ? Building.near([lat, lon], 0.1).where('id<>?', id).limit(4).includes(:addresses) : []
  end

  attr_writer :residents

  def residents
    @residents ||= BuildingResidentsLoader.new(building: self).call
  end

  def families
    @families = residents&.group_by(&:dwelling_number)
  end

  CensusYears.each do |year|
    define_method("families_in_#{year}") do
      send("census_#{year}_records").group_by(&:family_id)
    end
  end

  memoize def frame_type
    ConstructionMaterial.find frame_type_id
  end

  memoize def lining_type
    ConstructionMaterial.find lining_type_id
  end

  def building_types
    BuildingType.from_mask(building_types_mask)
  end

  def building_type_ids
    BuildingType.ids_from_mask(building_types_mask)
  end

  def building_type_ids=(ids)
    self.building_types_mask = BuildingType.mask_from_ids(ids)
  end

  private

  def validate_primary_address
    primary_addresses = addresses.to_a.select(&:is_primary)
    if primary_addresses.blank?
      errors.add(:base, 'Primary address missing.')
    elsif primary_addresses.size > 1
      errors.add(:base, 'Multiple primary addresses not allowed.')
    end
  end

  def check_locality
    return if locality_id.present?

    self.locality = Locality.first if Locality.count == 1
  end
end
