module StartupGenome
  class ImportOrganizations
    include Service

    def call
      results = StartupGenome::API.new.get_organizations
      persist(JSON.parse results.body)
    end
  
    private

    def persist(orgs)
      orgs.first[1].each do |org|
        create_or_update_organization(org)
      end
    end

    def create_or_update_organization(org)
      data = build_data_hash(org)
      organization = Organization.find_or_initialize_by(startup_genome_id: org[1]["organization_id"])
      organization.update(data) ? print(true, org[1]["name"]) : print(false, org[1]["name"])
    end

    def build_data_hash(org)
      { name: org[1]["name"],
        headline: org[1]["headline"],
        description: org[1]["description"],
        hiring_url: org[1]["hiring_url"],
        active: org[1]["active"],
        approved: org[1]["approved"],
        startup_genome_slug: org[1]["slug"],
        url: org[1]["url"],
        founded: org[1]["founded"].to_i,
        startup_genome_id: org[1]["organization_id"] }
    end

    def print(success, org_name)
      puts success ? "Successfully created/updated #{org_name}" : "Failed to update #{org_name}"
    end
  end
end
