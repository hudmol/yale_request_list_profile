module HarvardAeon
  class ResourceMapper < ItemMapper

    RequestList.register_item_mapper(self, :yale_aeon, Resource)

    def request_permitted?(item)
      # only if childless
      ArchivesSpaceClient.instance.get_raw_record(item['uri'] + '/tree/root')['child_count'] == 0
    end


    def form_fields(mapped)
      shared_fields = {
        'Site'          => mapped.ext(:site).name,
        'ReferenceNumber' => mapped.ext(:hollis).id,
        'ItemTitle'     => mapped.collection.name,
        'ItemAuthor'    => mapped.creator.name,
        'ItemDate'      => mapped.date.name,
        'Location'      => mapped.ext(:location).name,
        'SubLocation'   => mapped.ext(:physical_location).name,
        'CallNumber'    => mapped.collection.id,
        'ItemInfo2'     => mapped.collection.ext(:access_restrictions),
      }

      return [as_aeon_request(shared_fields)] unless mapped.container.has_multi?

      mapped.container.multi.map {|c|
        as_aeon_request(with_mapped_container(mapped, shared_fields, c))
      }
    end

  end
end
