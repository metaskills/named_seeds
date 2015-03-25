require 'test_helper'

class NamedSeedsTest < NamedSeeds::TestCase

  named_seeds :users
  named_seeds :posts
  named_seeds :states, identities: {virginia: 'VA', washington: 'WA'}
  named_seeds :enterprise_objects

  named_seeds :natural_id_states, identities: :natural, class: State
  named_seeds :classy_users, class: User
  named_seeds :no_model_class


  def test_generated_method_that_can_find_a_record
    assert_equal @@ken, users(:ken)
  end

  def test_not_found_is_just_plain_active_record_exceptions
    assert_raise(ActiveRecord::RecordNotFound) { users(:not_found) }
  end

  def test_can_pass_multiple_names_to_fixture_accessor
    assert_equal [@@ken, @@john], users(:ken, :john)
    assert_equal [@@virginia, @@washington], states(:virginia, :washington)
    assert_equal [@@virginia, @@washington], natural_id_states('VA', 'WA')
  end

  def test_can_find_string_primary_keys_using_identities_hash_option
    assert_equal @@virginia, states(:virginia)
  end

  def test_can_find_string_primary_keys_using_identities_natural_option
    assert_equal @@virginia, natural_id_states('VA')
  end

  def test_caches_fixture_lookups
    assert_equal users(:ken).object_id, users(:ken).object_id
  end

  def test_can_reset_the_fixture_lookup_cache
    ken1 = users(:ken)
    NamedSeeds.reset_cache
    ken2 = users(:ken)
    assert_not_equal ken1.object_id, ken2.object_id
  end

  def test_can_define_a_bad_named_seed_with_no_model_and_lazily_see_an_exception
    assert_raise(NamedSeeds::FixtureClassNotFound) { no_model_class(:name) }
  end

  def test_named_seeds_fixtur_class_not_found_subclasses_activerecords
    assert NamedSeeds::FixtureClassNotFound < ActiveRecord::FixtureClassNotFound
  end

  def test_can_find_named_seed_with_uuid_primary_key
    assert_equal @@enterprising_ken, enterprise_objects(:ken)
  end unless TESTING_RAILS_40

end

module SomeNamespace
  class User ; def self.find(id) ; self.new ; end ; end
  class NamespacedActiveSupportTest < NamedSeeds::TestCase

    named_seeds :users

    def test_generated_method_finds_proper_constant
      assert_equal @@ken, users(:ken)
    end

  end
end
