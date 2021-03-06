require "./github/**"

module Service::Github
  extend self

  def get_by_language(*args, **opts)
    Github::GraphQL::RepositorySearchQuery.fetch(**opts).search
  end

  def get_by_shardfile(*args, **opts)
    repos = Github::REST::ShardSearch.fetch_repos(**opts)
    node_ids = repos.map(&.node_id)
    Github::GraphQL::MultiRepositoryQuery.fetch(node_ids: node_ids).repos
  end

  def total_by_shardfile
    Github::REST::ShardSearch.total_count
  end

  def total_pages_by_shardfile(*, per_page = 100)
    (total_by_shardfile / per_page).ceil.to_i
  end
end
