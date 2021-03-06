xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xs="http://www.w3.org/2001/XMLSchema";

let $identifiers:= request:get-parameter("identifiers",0)
let $sequence:= tokenize($identifiers, '\|')

return
<results>
   {
         for $doc in $sequence
         let $path:= concat('/db/numishare/objects/', $doc, ".xml")
         return doc($path)/* 
      }
</results>