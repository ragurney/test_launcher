require "test_launcher/search/base"

module TestLauncher
  module Frameworks
    module Base
      class SearchResults < Search::Base
        def file_name_regex
          raise NotImplementedError
        end

        def file_name_pattern
          raise NotImplementedError
        end

        def regex_pattern
          raise NotImplementedError
        end
      end

      class Runner
        def single_example(result)
          raise NotImplementedError
        end

        def one_or_more_files(results)
          raise NotImplementedError
        end

        def single_file(result)
          one_or_more_files([result])
        end

        def multiple_files(collection)
          collection
            .group_by(&:app_root)
            .map { |_root, results| one_or_more_files(results) }
            .join("; cd -;\n\n")
        end
      end

      class TestCase < Search::TestCase
        def self.from_search(file:, line: nil)
          raise NotImplementedError
        end

        def test_root_folder_name
          raise NotImplementedError
        end
      end
    end
  end
end