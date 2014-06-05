CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    role        TEXT NOT NULL,
    age   	INTEGER NOT NULL,
    state  	TEXT NOT NULL
);

CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    cid         INTEGER REFERENCES categories (id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    SKU         TEXT NOT NULL UNIQUE,
    price       INTEGER NOT NULL
);

CREATE TABLE sales (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price		INTEGER NOT NULL
);

CREATE TABLE carts (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price 		INTEGER NOT NULL
);

CREATE TABLE states (
	name		TEXT PRIMARY KEY,
);


CREATE TABLE users_total (
	uid		INTEGER REFERENCES users (id),	
	total	INTEGER NOT NULL
);
INSERT INTO users_total SELECT uid, SUM(quantity*price) FROM sales GROUP BY uid;


CREATE TABLE products_total (
	pid		INTEGER REFERENCES products (id),	
	total	INTEGER NOT NULL
);
INSERT INTO products_total SELECT pid, SUM(quantity*price) FROM sales GROUP BY pid;

CREATE TABLE states_total (
	state	TEXT NOT NULL,
	total	INTEGER NOT NULL
);
INSERT INTO products_total SELECT pid, SUM(quantity*price) FROM sales GROUP BY pid;

CREATE TABLE users_product_total (
	uid		INTEGER REFERENCES users (id),	
	pid		INTEGER REFERENCES products (id),
	total	INTEGER NOT NULL
);
INSERT INTO users_product_total SELECT uid, pid, SUM(quantity*price) FROM sales GROUP BY pid, uid;

CREATE TABLE users_category_total (
	uid		INTEGER REFERENCES users (id),	
	cid		INTEGER REFERENCES categories (id),
	total	INTEGER NOT NULL
);

CREATE TABLE states_products_total (
	state 	TEXT NOT NULL,
	pid		INTEGER REFERENCES products (id),
	total	INTEGER NOT NULL
);

CREATE TABLE states_categories_total (
	state 	TEXT NOT NULL,
	cid		INTEGER REFERENCES categories (id),
	total	INTEGER NOT NULL
);
