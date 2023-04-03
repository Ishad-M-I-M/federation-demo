// Need to generate by code modifier plugin

type User record {|
    string id?;
    string? name?;
    string? username?;
    Review[]? reviews?;
|};

type Review record {|
    string id?;
    string? body?;
    User? author?;
    Product? product?;
|};

type Product record {|
    string upc?;
    int? weight?;
    int? price?;
    ProductDimension? dimensions?;
    boolean? inStock?;
    int? shippingEstimate?;
    string? name?;
    Review[]? reviews?;
|};

type ProductDimension record {|
    string upc?;
    int? width?;
    int? height?;
    int? depth?;
|};

type Union User|Review|Product|ProductDimension;

// The response types are generated by inspecting subgraphs and nesting the above defined corresponding types
// inside "data" and the respecive query name.

type meResponse record {
    record {|User me;|} data;
};

type topProductsResponse record {
    record {|Product[] topProducts;|} data;
};
