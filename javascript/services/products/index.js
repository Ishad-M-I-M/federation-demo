const { ApolloServer, gql } = require("apollo-server");
const { buildFederatedSchema } = require("@apollo/federation");

const typeDefs = gql`
  extend type Query {
    topProducts(first: Int = 5): [Product]
  }

  type Product @key(fields: "upc") {
    upc: String!
    name: String
    price: Int
    weight: Int
    dimensions: ProductDimension
  }

  type ProductDimension @key(fields: "upc") {
    upc: String!
    height: Int
    width: Int
    length: Int
  }
`;

const resolvers = {
  Product: {
    __resolveReference(object) {
      return products.find(product => product.upc === object.upc);
    }
  },
  Query: {
    topProducts(_, args) {
      return products.slice(0, args.first);
    }
  }
};

const server = new ApolloServer({
  schema: buildFederatedSchema([
    {
      typeDefs,
      resolvers
    }
  ])
});

server.listen({ port: 4003 }).then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});

const products = [
  {
    upc: "1",
    name: "Table",
    price: 899,
    weight: 100,
    dimensions: {
      upc: "1",
      height: 10,
      width: 10,
      length: 20
    }
  },
  {
    upc: "2",
    name: "Couch",
    price: 1299,
    weight: 1000,
    dimensions: {
      upc: "2",
      height: 10,
      width: 10,
      length: 10
    }
  },
  {
    upc: "3",
    name: "Chair",
    price: 54,
    weight: 50,
    dimensions: {
      upc: "3",
      height: 10,
      width: 5,
      length: 5
    }
  }
];
