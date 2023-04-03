// Need to generate by code modifier plugin

import ballerina/graphql;

final graphql:Client REVIEWS_CLIENT = check new graphql:Client("http://localhost:4002");
final graphql:Client INVENTORY_CLIENT = check new graphql:Client("http://localhost:4004");
final graphql:Client ACCOUNTS_CLIENT = check new graphql:Client("http://localhost:4001");
final graphql:Client PRODUCTS_CLIENT = check new graphql:Client("http://localhost:4003");

isolated function getClient(string clientName) returns graphql:Client {
    match clientName {
        "reviews" => {
            return REVIEWS_CLIENT;
        }
        "inventory" => {
            return INVENTORY_CLIENT;
        }
        "accounts" => {
            return ACCOUNTS_CLIENT;
        }
        "products" => {
            return PRODUCTS_CLIENT;
        }
        _ => {
            panic error("Client not found");
        }
    }
}

//Entry point to gateway. Will be generated

configurable int PORT = 9000;

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
        path: "/graphiql"
    }
}
isolated service on new graphql:Listener(PORT) {

    // Map to keep the client objects. The client objects will be created once.
    private map<graphql:Client> clients;

    isolated resource function get me(graphql:Field 'field) returns User|error {
        QueryFieldClassifier classifier = new ('field, queryPlan, ACCOUNTS);

        string fieldString = classifier.getFieldString();
        UnResolvableField[] propertiesNotResolved = classifier.getUnResolvableFields();

        string queryString = wrapwithQuery("me", fieldString);
        meResponse response = check ACCOUNTS_CLIENT->execute(queryString);

        User result = response.data.me;

        Resolver resolver = new (queryPlan, result, "User", propertiesNotResolved, ["me"]);
        json|error finalResult = resolver.getResult();
        if finalResult is error {
            return finalResult;
        } else {
            return finalResult.cloneWithType();
        }
    }

    isolated resource function get topProducts(graphql:Field 'field, int first = 5) returns Product[]|error {
        QueryFieldClassifier classifier = new ('field, queryPlan, PRODUCTS);

        string fieldString = classifier.getFieldString();
        UnResolvableField[] propertiesNotResolved = classifier.getUnResolvableFields();

        string queryString = wrapwithQuery("topProducts", fieldString, {"first": first.toString()});
        topProductsResponse response = check PRODUCTS_CLIENT->execute(queryString);

        Product[] result = response.data.topProducts;

        Resolver resolver = new (queryPlan, result.toJson(), "Product", propertiesNotResolved, ["topProducts"]);
        json|error finalResult = resolver.getResult();
        if finalResult is error {
            return finalResult;
        } else {
            return finalResult.cloneWithType();
        }

    }

}
