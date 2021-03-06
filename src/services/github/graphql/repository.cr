require "./connection"
require "./ref"

class Service::Github::GraphQL::Repository
  JSON.mapping(
    url: String,
    updated_at: {type: Time?, key: "updatedAt"},
    homepage_url: {type: String?, key: "homepageUrl"},
    name_with_owner: {type: String, key: "nameWithOwner"},
    watchers: Service::Github::GraphQL::Connection(Nil),
    forks: Service::Github::GraphQL::Connection(Nil),
    stargazers: Service::Github::GraphQL::Connection(Nil),
    pull_requests: {type: Service::Github::GraphQL::Connection(Nil), key: "pullRequests"},
    issues: {type: Service::Github::GraphQL::Connection(Nil), key: "issues"},
    tags: Service::Github::GraphQL::Connection(Github::GraphQL::Ref)
  )

  FRAGMENT = <<-graphql
  fragment repo_fragment on Repository {
    url
    homepageUrl
    updatedAt
    nameWithOwner
    watchers {
      totalCount
    }
    forks {
      totalCount
    }
    stargazers {
      totalCount
    }
    pullRequests {
      totalCount
    }
    issues {
      totalCount
    }
    tags: refs(refPrefix: "refs/tags/", first: 100) {
      nodes {
        ...ref
      }
    }
  }

  #{Service::Github::GraphQL::Ref::FRAGMENT}
  graphql
end
