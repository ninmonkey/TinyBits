![screenshot of rows](./Auto-Incrementing-Id-Rows-Formula.png)

If `D` is a column you can use `D.:.D`

Or use a table name.


### to Start from 1


```
=LET( src,  D.:.D,
   rows,    DROP( src, 1 ),
   numRows, COUNTA( rows ),
   SEQUENCE( numRows )
)
```

### to Start from 0

```
=LET( src,  D.:.D,
   rows,    DROP( src, 1 ),
   numRows, COUNTA( rows ),
     SEQUENCE( numRows, , 0)
)
```