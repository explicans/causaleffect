verma.constraints <- function(G) {
  if (length(edge.attributes(G)) == 0) {
    G <- set.edge.attribute(G, "description", 1:length(E(G)), NA)
  }
  G.obs <- observed.graph(G)
  G.unobs <- unobserved.graph(G)
  G.adj <- as.matrix(get.adjacency(G.unobs))
  topo <- topological.sort(G.obs)
  topo.u <- topological.sort(G.unobs)
  v <- get.vertex.attribute(G, "name")[topo]
  v.unobs <- get.vertex.attribute(G.unobs, "name")[topo.u]
  constraints <- list()
  s <- NULL
  for (i in 1:length(v)) {
    vi <- v[1:i]
    G.vi <- induced.subgraph(G, vi)
    cc <- c.components(G.vi, v)
    if (length(cc) > 1) s <- Find(function(x) v[i] %in% x, cc)
    else s <- cc[[1]]
    # pa.s <- parents(s, G.obs, v)
    # pred <- setdiff(vi, pa.s)
    # if (length(pred) > 0) {
    #   eff <- setdiff(pa.s, v[i])
    #   if (dSep(G.adj, v[i], pred, eff)) {
    #     constraints <- c(constraints, list(c(
    #       "X" = v[i], 
    #       "Y" = paste0(pred, collapse = ","), 
    #       "Z" = paste0(eff, collapse = ",")
    #     )))
    #   }
    # }
    constraints <- c(constraints, q.constraints(s, v[i], G, G.obs, G.unobs, v, v.unobs, list()))
  }
  return(constraints)
}