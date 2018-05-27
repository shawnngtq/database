# Mongodb Cheatsheet
- https://gist.github.com/aponxi/4380516
- https://gist.github.com/brpaz/ee9f1d3aff20e26d006d

## Terminology & concepts
| SQL         | Mongodb                         |
| ---         | ---                             |
| database    | database                        |
| table       | collections                     |
| row         | (BSON) document                 |
| column      | field                           |
| index       | index                           |
| table joins | embedded documents and linking  |
| primary key | primary key                     |
| aggregation | aggregation framework           |

- For SQL, any column or column combination can be key. In Mongodb, key is auto set to `id` field
