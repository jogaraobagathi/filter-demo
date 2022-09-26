
CREATE TYPE action_type AS ENUM ('ALLOW','BLOCK');

CREATE TABLE IF NOT EXISTS filter_table (
                                               id           int  NOT NULL ,
                                               condition_   jsonb,
                                               priority int,
                                               action_  action_type DEFAULT 'ALLOW',
                                               PRIMARY KEY (id));