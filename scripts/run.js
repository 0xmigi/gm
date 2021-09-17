async function main() {
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({value: hre.ethers.utils.parseEther("0.1")})

    await waveContract.deployed()

    console.log("Contract addy:", waveContract.address)

    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
    console.log("Balance: ", hre.ethers.utils.formatEther(contractBalance))

    let waveTxn = await waveContract.wave("this is wave #1")
    await waveTxn.wait()

    waveTxn = await waveContract.wave("this is wave #2")
    await waveTxn.wait()

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance))
}
    
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    process.exit(1)
})

