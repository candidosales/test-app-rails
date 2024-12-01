module Resolvers
  class ArticleResolver < BaseResolver
    type Types::ArticleType, null: false
    argument :id, ID

    def resolve(id:)
      ::Article.find(id)
    end
  end
end