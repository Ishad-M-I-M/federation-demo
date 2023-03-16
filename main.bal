// Need to generate by code modifier plugin

import ballerina/graphql;

//Entry point to gateway. Will be generated

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
        path: "/graphiql"
    }
}
service on new graphql:Listener(9000) {

    // Map to keep the client objects. The client objects will be created once.
    private map<graphql:Client> clients;

    function init() returns error? {
        self.clients = {
            "accounts": check new graphql:Client("http://localhost:4001"),
            "reviews": check new graphql:Client("http://localhost:4002"),
            "products": check new graphql:Client("http://localhost:4003"),
            "inventory": check new graphql:Client("http://localhost:4004")
        };
    }

    isolated resource function get me(graphql:Field 'field) returns User|error {
        graphql:Client 'client = self.clients.get("accounts");
        QueryFieldClassifier classifier = new ('field, "accounts");

        string fieldString = classifier.getFieldString();
        unResolvableField[] propertiesNotResolved = classifier.getUnresolvableFields();

        string queryString = wrapwithQuery("me", fieldString);
        MeResponse response = check 'client->execute(queryString);

        User result = response.data.me;

        Resolver resolver = new (self.clients, result, "User", propertiesNotResolved, ["me"]);
        return resolver.getResult().ensureType();

    }

    isolated resource function get topProducts(graphql:Field 'field, int first = 5) returns Product[]|error {
        graphql:Client 'client = self.clients.get("products");
        QueryFieldClassifier classifier = new ('field, "products");

        string fieldString = classifier.getFieldString();
        unResolvableField[] propertiesNotResolved = classifier.getUnresolvableFields();

        string queryString = wrapwithQuery("topProducts", fieldString, {"first": first.toString()});
        topProductsResponse response = check 'client->execute(queryString);

        Product[] result = response.data.topProducts;

        Resolver resolver = new (self.clients, result, "Product", propertiesNotResolved, ["topProducts"]);
        return resolver.getResult().ensureType();

    }

}
