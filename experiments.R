library(DiagrammeR)
library(pipeR)
library(XML)
library(htmltools)

exportSVG(
  grViz('
    digraph G {
        size = "4,4";
        main [shape = box]; /* this is a comment */
        main -> parse [weight = 8];
        parse -> execute;
        main -> init [style = dotted];
        main -> cleanup;
        execute -> { make_string; printf}
        init -> make_string;
        edge [color = red]; // so is this
        main -> printf;
        node [shape = box, style = filled, color = ".7 .3 1.0"];
        execute -> compare;
        }
  ')
) %>>%
  htmlParse %>>%
~svgDiag


svgDiag %>>%
  getNodeSet("//g[contains(@class,'node')]") %>>%
  lapply(
    function(el){
      addAttributes( el, "class" = "node hvr-float", "style" = "pointer-events:all;")
      if(length(xmlChildren(el)$title)>0){
        removeChildren(el, kids = list(xmlChildren(el)$title))
      }
      return(NULL)
    }
  )

svgDiag %>>%
  saveXML %>>%
  HTML() %>>% 
  attachDependencies(
    htmlDependency(
      name="hover.css"
      ,version = "0.1"
      ,src = c(file=paste0(getwd(),"/css"))
      ,stylesheet = "hover.css"
    )
  ) %>>%
  html_print %>>%
~htF


#library(gistr)
#gist_auth(reauth=T)
#gist_create(
#  list.files(dirname(htF),full.names=T,recursive=T)
#  ,description = "hover.css applied to DiagrammeR grViz"
#)