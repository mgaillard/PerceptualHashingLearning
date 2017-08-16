function bstop = DisplayOptimState(x, optv, state)
  fprintf("%d\t%d\n", optv.iter, optv.fval);
  bstop = false;
end