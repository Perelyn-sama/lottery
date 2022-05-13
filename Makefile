# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# Install the Modules
install :; 
	forge install dapphub/ds-test 
	forge install OpenZeppelin/openzeppelin-contracts

deploy:
	forge create --rpc-url ${LOCAL_RPC_URL} --constructor-args 2274 --private-key ${LOCAL_PRIVATE_KEY} src/Merge.sol:VRFv2Consumer 

d: 
	forge create --rpc-url ${LOCAL_RPC_URL} --private-key ${LOCAL_PRIVATE_KEY} src/Lottery.sol:Lottery 

abi: 
	cast abi-encode "constructor(uint64)" 2274

verify:
	forge verify-contract --chain-id 4 --num-of-optimizations 200 --constructor-args 0x00000000000000000000000000000000000000000000000000000000000008e2 --compiler-version v0.8.10+commit.fc410830 0x5fbdb2315678afecb367f032d93f642f64180aa3 src/CustomNFT.sol:CustomNFT ${ETHERSCAN_KEY}

verify-check: 
	forge verify-check --chain-id 4 dfxrzgvtfwv8cdgg4cgx21rekrhr3hmfjsu9td8a7kfkamsk99 ${ETHERSCAN_KEY}

setBaseUri: 
	  cast send --rpc-url ${LOCAL_RPC_URL} 0x5fbdb2315678afecb367f032d93f642f64180aa3  "setBaseURI(string)" "https://gateway.pinata.cloud/ipfs/QmfAASejhcLL3MrmSpUwZyhv9DnyBrCsNxASVpbTzTjS3P" --private-key ${LOCAL_PRIVATE_KEY}

alt:
	cast call --rpc-url ${LOCAL_RPC_URL} --private-key ${LOCAL_PRIVATE_KEY} 0x5fbdb2315678afecb367f032d93f642f64180aa3 "saleConfig" --etherscan-api-key ${ETHERSCAN_KEY} 


