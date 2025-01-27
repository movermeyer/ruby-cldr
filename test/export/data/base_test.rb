# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestBase < Test::Unit::TestCase
  test "#paths finds all the language-dependent data files" do
    expected = [
      "annotations/af.xml",
      "annotationsDerived/af.xml",
      "casing/af.xml",
      "collation/af.xml",
      "main/af.xml",
      "rbnf/af.xml",
      "subdivisions/af.xml",
    ].map { |f| File.join(Cldr::Export::Data.dir, f) }
    assert_equal expected, Cldr::Export::Data::Base.new("af").send(:paths)
  end

  test "#paths finds all the supplemental data files" do
    expected_non_transform_files = [
      "supplemental/attributeValueValidity.xml",
      "supplemental/characters.xml",
      "supplemental/coverageLevels.xml",
      "supplemental/dayPeriods.xml",
      "supplemental/genderList.xml",
      "supplemental/languageGroup.xml",
      "supplemental/languageInfo.xml",
      "supplemental/likelySubtags.xml",
      "supplemental/metaZones.xml",
      "supplemental/numberingSystems.xml",
      "supplemental/ordinals.xml",
      "supplemental/pluralRanges.xml",
      "supplemental/plurals.xml",
      "supplemental/rgScope.xml",
      "supplemental/subdivisions.xml",
      "supplemental/supplementalData.xml",
      "supplemental/supplementalMetadata.xml",
      "supplemental/windowsZones.xml",
      "validity/currency.xml",
      "validity/language.xml",
      "validity/region.xml",
      "validity/script.xml",
      "validity/subdivision.xml",
      "validity/unit.xml",
      "validity/variant.xml",
    ].map { |f| File.join(Cldr::Export::Data.dir, f) }

    supplemental_data_paths = Cldr::Export::Data::Base.new(nil).send(:paths)

    assert_equal expected_non_transform_files, supplemental_data_paths.reject { |p| p.include?("transforms/") }
    assert_not_empty supplemental_data_paths.select { |p| p.include?("transforms/") }
  end
end
