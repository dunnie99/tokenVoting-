import { ethers } from "hardhat";


async function  main(){
const [admin] = await ethers.getSigners();
 
  const TokenvotingContract =  await ethers.getContractFactory("tokenVoting");

  const TokenVotingContract = await TokenvotingContract.deploy("Dunnie","DUNS", 5000);

  await TokenVotingContract.deployed();

  console.log(`tokenVoting Contract address is ${TokenVotingContract.address}`);

  let AddressToken = admin.address;

  let tokenName = await TokenVotingContract.name();

  console.log(tokenName);

  let tokenSymbol = await TokenVotingContract.symbol();
  console.log(tokenSymbol);

  let tokenDecimal = await TokenVotingContract.decimal();

  console.log(tokenDecimal);

  let tokenMint = await TokenVotingContract.mint(5000);

  console.log(tokenMint);

  

  let tokenBalance = await TokenVotingContract._balanceOf(AddressToken);
  console.log(tokenBalance);

  let transfer = await TokenVotingContract.transfer("0x20e77cD9C1a3EeA1Bb1BD64da536a33B0df7248e", "10");
    console.log(await transfer.wait().then((e: any) => e.events[0].args));

  let votingRegistration = await TokenVotingContract.registerContenders("0x20e77cD9C1a3EeA1Bb1BD64da536a33B0df7248e","0xA2d1B5D60cc5b2E8b99bE8E043059823e2F0aFCe","0x0B85caaeB9cbC780b016f1088BD3deA58c82324F");
  console.log(votingRegistration);
  console.log(await votingRegistration.wait().then((e: any) => e.events[0].args));

  let Votebegins = await TokenVotingContract.connect(admin).startVote();
  console.log(Votebegins);

  let votingPoll = await TokenVotingContract.Voting("0x0B85caaeB9cbC780b016f1088BD3deA58c82324F", "0x20e77cD9C1a3EeA1Bb1BD64da536a33B0df7248e", "0xA2d1B5D60cc5b2E8b99bE8E043059823e2F0aFCe");
  console.log(votingPoll);

  let VoteEnd = await TokenVotingContract.connect(admin).endVote();
  console.log(VoteEnd);

  let roundup = await TokenVotingContract.getAllVote("0x0B85caaeB9cbC780b016f1088BD3deA58c82324F");
    console.log(roundup);
  

  
}

main().catch(e => {
    console.log(e);
    process.exitCode = 1;
})