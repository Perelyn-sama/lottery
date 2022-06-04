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

abi2: 
	cast abi-encode "s_randomWords(uint256)" 0


verify:
	forge verify-contract --chain-id 4 --num-of-optimizations 200 --constructor-args 0x00000000000000000000000000000000000000000000000000000000000008e2 --compiler-version v0.8.10+commit.fc410830 0x6c8102eacf796afc19b3660be019ea3db9009c0e src/Merge.sol:VRFv2Consumer ${ETHERSCAN_KEY}

verify-check: 
	forge verify-check --chain-id 4 dfxrzgvtfwv8cdgg4cgx21rekrhr3hmfjsu9td8a7kfkamsk99 ${ETHERSCAN_KEY}

setBaseUri: 
	  cast send --rpc-url ${LOCAL_RPC_URL} 0x6c8102eacf796afc19b3660be019ea3db9009c0e  "setBaseURI(string)" "https://gateway.pinata.cloud/ipfs/QmfAASejhcLL3MrmSpUwZyhv9DnyBrCsNxASVpbTzTjS3P" --private-key ${LOCAL_PRIVATE_KEY}

words:
	cast call --rpc-url ${LOCAL_RPC_URL} --private-key ${LOCAL_PRIVATE_KEY} 0x6c8102eacf796afc19b3660be019ea3db9009c0e "s_randomWords(string)(string)" "0"



