module Spectrum
  module Config
    class IconMetadataComponent < MetadataComponent
      type 'icon'

      MAP = {
        'Archive' => 'archive',
        'Art' => 'photo',
        'Article' => 'document',
        'Audio' => 'volume_up',
        'Audio (music)' => 'volume_up',
        'Audio (spoken word)' => 'volume_up',
        'Audio CD' => 'volume_up',
        'Audio LP' => 'volume_up',
        'Biography' => 'book',
        'Book' => 'book',
        'Book Chapter' => 'document',
        'CDROM' => 'music_note',
        'Conference' => 'book',
        'Data File' => 'insert_drive_file',
        'Dictionaries' => 'collection_bookmark',
        'Directories' => 'collection_bookmark',
        'eBook' => 'book',
        'Electronic Resource' => 'web',
        'Encyclopedias' => 'book',
        'Journal' => 'collection_bookmark',
        'Manuscript' => 'document',
        'Map' => 'map',
        'Maps-Atlas' => 'map',
        'Microform' => 'theaters',
        'Mixed Material' => 'filter',
        'Motion Picture' => 'theaters',
        'Music' => 'music_note',
        'Musical Score' => 'music_note',
        'Newspaper' => 'newspaper',
        'Photographs & Pictorial Works' => 'photo_library',
        'Serial' => 'collection_bookmark',
        'Software' => 'code',
        'Statistics' => 'timeline',
        'Unknown' => '',
        'Video (Blu-ray)' => 'play_circle',
        'Video (DVD)' => 'play_circle',
        'Video (VHS)' => 'play_circle',
        'Video Games' => 'videogame_asset',
        'Visual Material' => 'remove_red_eye',
        'Website' => 'web',
        'Web Resource' => 'web',
        'Government Document' => 'document',
        'Newsletter' => 'document',
        'Poem' => 'document',
        'Publication' => 'document',
        'Trade Publication Article' => 'document',
        'Streaming Audio' => 'volume_up',
        'Photograph' => 'photo_library',
        'Image' => 'photo_library',
        'Painting' => 'photo_library',
        'Streaming Video' => 'play_circle',
        'Archival Material' => 'archive',
        'Database' => 'insert_drive_file',
        'Online Journal' => 'collection_bookmark',
      }

      def initialize(name, config)
        config ||= {}
        self.name = name
      end

      def get_description(data)
        [data].flatten(1).map { |item|
          item = item.to_s
          icon = MAP[item].to_s
          if item.empty?
            nil
          elsif icon.empty?
            {text: item}
          else
            {text: item, icon: icon}
          end
        }.compact
      end

      def resolve(data)
        description = get_description(data)
        return nil if description.empty?
        {
          term: name,
          description: description,
        }
      end
    end
  end
end
