fillPiece(TabIn,RowN,ColN,Player,TabOut) :-
  nth1(RowN,TabIn,Row,_), %retrieve row
  select(Row,TabIn,NewTab), %delete old row
  nth1(ColN,Row,Col,_), %retrieve column
  select(Col,Row,NewRow), %delete old column
  [_|ID] is Col, %retrieve piece ID
  nth1(ColN,NRow,[Player|ID],NewRow), %insert col into row
  nth1(RowN,TabOut,NRow,NewTab). % insert row into tab