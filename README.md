# company Tech Problem

This is my submission for the tech problem provided by company. I have never used
the stack hardhat+waffle+ether.js+chai so I was only able to complete one test contract
with the limited time I had today.

## Logic Behind Lottery

The problem with not using API or oracles off-chain to make a random number is
that blockchains are made to be deterministic which is inherently against randomness.
This also coupled with using on-chain methods such as block.timestamp can be slightly
manipulated by miners to alter the outcome of "random" events. If I was forced to
come up with a method that uses on-chain information and that alone I would use
a combination of three block.timestamps: one that is logged when the contract
is deployed, one manually chosen from timestamps logged when buyTicket was called, and one
when the draw method is called. I believe this would almost be as secure as you will
get since the miner from when the contract is deployed, the buyer of the selected ticket
and/or miner of that block plus the miner of the block at the time of the draw all
has to be malicious actors to have an effect on the randomness. This assumes that
that this is for a blockchain that doesn't have an integrated VRF(verifiable random function)
like Cardano.
