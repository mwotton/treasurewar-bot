
fairly basic subsumption architecture - every argument after the first is the name of a strategy class. Each strategy will be asked to make a move: it will either return a move or nil. if it returns nil, the next strategy will be asked. Call it a poor man's monad.


bundle exec ruby driver.rb MrPotatoHead  PickupTreasure PickupStash Dropper StashReturner TreasureSeeker StashSeeker Killerstrat KillSeeker WallHugger DrunkWalker 2>errs

