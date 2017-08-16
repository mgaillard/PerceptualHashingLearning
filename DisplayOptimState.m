function bstop = DisplayOptimState(x, optv, state)
  fprintf("%d\t%d\n", optv.iter, optv.fval);
  fflush(stdout);
  bstop = false;
end