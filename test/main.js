/*
This is the test file for Prescience is here: https://github.com/sanchaymittal/prescience.

This test file has been updated for Truffle version 5.0. If your tests are failing, make sure that you are
using Truffle version 5.0. You can check this by running "truffle version"  in the terminal. If version 5 is not
installed, you can uninstall the existing version with `npm uninstall -g truffle` and install the latest version (5.0)
with `npm install -g truffle`.
*/

let BN = web3.utils.BN
let Main = artifacts.require('Main')
let catchRevert = require("./exceptionHelpers.js").catchRevert

contract('Main', function(accounts) {

    const owner = accounts[0]
    const alice = accounts[1]
    const bob = accounts[2]
    const emptyAddress = '0x0000000000000000000000000000000000000000'
    const Id = 0;

    const set = ["Facebook Libra Coin", "Description", "any file", 30,30,30];
    const minReviewTimePeriodLength = 10;
    const maxReviewTimePeriodLength = 11 * 24 * 60 * 60;
    const minCommitTimePeriodLength = 10;
    const maxCommitTimePeriodLength = 11 * 24 * 60 * 60;
    const minRevealTimePeriodLength = 10;
    const maxRevealTimePeriodLength = 11 * 24 * 60 * 60;
    const iset = ["Facebook Libra Coin", "Description", "any file", 30,30,30, 1000000000, 1000000000];
    
    const price = "1000"
    const excessAmount = "2000"
    const name = "book"

    let instance

    beforeEach(async () => {
        instance = await Main.new()
    })

    it("should create a proposal, which includes Topic, Description, Documents, Review Time, Commit Time and Reveal Time ", async() => {
        const tx = await instance.Proposal(set[0],set[1],set[2], set[3],set[4],set[5], {from: alice})
        const expected = 0;
        const result = await instance.getProposalDetails.call(0)
        const ContractAddress = await instance.Proposals.call(0)

        assert.equal(expected, Id, 'The Id of the created contract do not match to the expected proposal Id')
        assert.equal(result[0], alice, 'the address creating the proposal should be listed as the Admin')
        assert.equal(result[1], ContractAddress, 'The Adresses of the created contract do not match to the expected contract address')
        assert.equal(result[2], set[0], 'the topic of the last addded item do not match the expected value')
        assert.equal(result[3], set[1], 'the description of the last addded item do not match the expected value')
    })

    it("should create a Incentive proposal, which includes Topic, Description, Documents, Review Time, Commit Time and Reveal Time ", async() => {
        const tx = await instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],iset[4],iset[5],iset[6], iset[7], {from: alice})
        const expected = 0;
        const result = await instance.getIncentivizedProposal.call(0)
        const ContractAddress = await instance.IncentivizeProposals.call(0)

        assert.equal(expected, Id, 'The Id of the created contract do not match to the expected proposal Id')
        assert.equal(result[0], alice, 'the address creating the proposal should be listed as the Admin')
        assert.equal(result[1], ContractAddress, 'The Adresses of the created contract do not match to the expected contract address')
        assert.equal(result[2], iset[0], 'the topic of the last addded item do not match the expected value')
        assert.equal(result[3], iset[1], 'the description of the last addded item do not match the expected value')
    })

    it("should emit an SuccessfullyProposalCreated event when an Proposal is added", async()=> {
        let eventEmitted = false
        const tx = await instance.Proposal(set[0],set[1],set[2], set[3],set[4],set[5], {from: alice})
        
        if (tx.logs[0].event == "SuccessfullyProposalCreated") {
            eventEmitted = true
        }

        assert.equal(eventEmitted, true, 'Creating a Proposal should emit a Success event')
    })

    it("should emit an SuccessfullyIncentivizedProposalCreated event when an Proposal is added", async()=> {
        let eventEmitted = false
        const tx = await instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],iset[4],iset[5], iset[6],iset[7], {from: alice})
        
        if (tx.logs[0].event == "SuccessfullyIncentivizedProposalCreated") {
            eventEmitted = true
        }

        assert.equal(eventEmitted, true, 'Creating a Incentivize Proposal should emit a Success event')
    })

    // it("should allow someone to purchase an item and update state accordingly", async() => {

    //     await instance.addItem(name, price, {from: alice})
    //     var aliceBalanceBefore = await web3.eth.getBalance(alice)
    //     var bobBalanceBefore = await web3.eth.getBalance(bob)

    //     await instance.buyItem(0, {from: bob, value: excessAmount})

    //     var aliceBalanceAfter = await web3.eth.getBalance(alice)
    //     var bobBalanceAfter = await web3.eth.getBalance(bob)

    //     const result = await instance.fetchItem.call(0)

    //     assert.equal(result[3].toString(10), 1, 'the state of the item should be "Sold", which should be declared second in the State Enum')
    //     assert.equal(result[5], bob, 'the buyer address should be set bob when he purchases an item')
    //     assert.equal(new BN(aliceBalanceAfter).toString(), new BN(aliceBalanceBefore).add(new BN(price)).toString(), "alice's balance should be increased by the price of the item")
    //     assert.isBelow(Number(bobBalanceAfter), Number(new BN(bobBalanceBefore).sub(new BN(price))), "bob's balance should be reduced by more than the price of the item (including gas costs)")
    // })

    it("should error when Review Time for Proposal is less than 20 seconds ", async()=>{
        await catchRevert(instance.Proposal(set[0],set[1],set[2], minReviewTimePeriodLength,set[4],set[5], {from: alice}))
    })
    it("should error when Commit Time for Proposal is less than 20 seconds ", async()=>{
        await catchRevert(instance.Proposal(set[0],set[1],set[2], set[3], minCommitTimePeriodLength,set[5], {from: alice}))
    })
    it("should error when Reveal Time for Proposal is less than 20 seconds ", async()=>{
        await catchRevert(instance.Proposal(set[0],set[1],set[2],set[3],set[4], minRevealTimePeriodLength, {from: alice}))
    })
    it("should error when Review Time for Proposal is more than 10 days", async()=>{
        await catchRevert(instance.Proposal(set[0],set[1],set[2], maxReviewTimePeriodLength,set[4], set[5], {from: alice}))
    })
    it("should error when Commit Time for Proposal is more than 10 days", async()=>{
        await catchRevert(instance.Proposal(set[0],set[1],set[2], set[3],maxCommitTimePeriodLength, set[5], {from: alice}))
    })
    it("should error when Reveal Time for Proposal is more than 10 days", async()=>{
        await catchRevert(instance.Proposal(set[0],set[1],set[2],set[3], set[4], maxRevealTimePeriodLength, {from: alice}))
    })

    it("should error when Review Time for Incentivize Proposal is less than 20 seconds ", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], minReviewTimePeriodLength,iset[4],iset[5], iset[6], iset[7], {from: alice}))
    })
    it("should error when Commit Time for Incentivize Proposal is less than 20 seconds ", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],minCommitTimePeriodLength,iset[5],iset[6], iset[7], {from: alice}))
    })
    it("should error when Reveal Time for Incentivize Proposal is less than 20 seconds ", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],iset[4],minRevealTimePeriodLength,iset[6], iset[7], {from: alice}))
    })
    it("should error when Review Time for Incentivize Proposal is more than 10 days", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], maxReviewTimePeriodLength,iset[4],iset[5],iset[6], iset[7], {from: alice}))
    })
    it("should error when Commit Time for Incentivize Proposal is more than 10 days", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],maxCommitTimePeriodLength,iset[5],iset[6], iset[7], {from: alice}))
    })
    it("should error when Reveal Time for Incentivize Proposal is more than 10 days", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],iset[4],maxRevealTimePeriodLength,iset[6], iset[7], {from: alice}))
    })
    it("should error when set Security Deposit for Incentivize Proposal is less than 0.0001 ether", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],iset[4],iset[5], 10000, iset[7], {from: alice}))
    })
    
    it("should error when set Security Deposit for Incentivize Proposal is more than 1 ether", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],iset[4],iset[5], 2000000000, iset[7], {from: alice}))
    })
    
    it("should error when set Reward for Incentivize Proposal is less than Security Deposit", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],iset[4],iset[5], iset[6],10000, {from: alice}))
    })

    it("should error when set Reward for Incentivize Proposal is more than 2 Ether", async()=>{
        await catchRevert(instance.incentivizeProposal(iset[0],iset[1],iset[2], iset[3],iset[4],iset[5], iset[6], 3000000000, {from: alice}))
    })

    
    
    // it("should emit LogSold event when and item is purchased", async()=>{
    //     var eventEmitted = false

    //     await instance.addItem(name, price, {from: alice})
    //     const tx = await instance.buyItem(0, {from: bob, value: excessAmount})

    //     if (tx.logs[0].event == "LogSold") {
    //         eventEmitted = true
    //     }

    //     assert.equal(eventEmitted, true, 'adding an item should emit a Sold event')
    // })

    // it("should revert when someone that is not the seller tries to call shipItem()", async()=>{
    //     await instance.addItem(name, price, {from: alice})
    //     await instance.buyItem(0, {from: bob, value: price})
    //     await catchRevert(instance.shipItem(0, {from: bob}))
    // })

    // it("should allow the seller to mark the item as shipped", async() => {

    //     await instance.addItem(name, price, {from: alice})
    //     await instance.buyItem(0, {from: bob, value: excessAmount})
    //     await instance.shipItem(0, {from: alice})
	
    //     const result = await instance.fetchItem.call(0)

    //     assert.equal(result[3].toString(10), 2, 'the state of the item should be "Shipped", which should be declared third in the State Enum')
    // })

    // it("should emit a LogShipped event when an item is shipped", async() => {
    //     var eventEmitted = false

    //     await instance.addItem(name, price, {from: alice})
    //     await instance.buyItem(0, {from: bob, value: excessAmount})
    //     const tx = await instance.shipItem(0, {from: alice})

    //     if (tx.logs[0].event == "LogShipped") {
    //         eventEmitted = true
    //     }

    //     assert.equal(eventEmitted, true, 'adding an item should emit a Shipped event')
    // })

    // it("should allow the buyer to mark the item as received", async() => {
    //     await instance.addItem(name, price, {from: alice})
    //     await instance.buyItem(0, {from: bob, value: excessAmount})
    //     await instance.shipItem(0, {from: alice})
    //     await instance.receiveItem(0, {from: bob})
	
    //     const result = await instance.fetchItem.call(0)

    //     assert.equal(result[3].toString(10), 3, 'the state of the item should be "Received", which should be declared fourth in the State Enum')
    // })

    // it("should revert if an address other than the buyer calls receiveItem()", async() =>{
    //     await instance.addItem(name, price, {from: alice})
    //     await instance.buyItem(0, {from: bob, value: excessAmount})
    //     await instance.shipItem(0, {from: alice})
        
    //     await catchRevert(instance.receiveItem(0, {from: alice}))
    // })

    // it("should emit a LogReceived event when an item is received", async() => {
    //     var eventEmitted = false

    //     await instance.addItem(name, price, {from: alice})
    //     await instance.buyItem(0, {from: bob, value: excessAmount})
    //     await instance.shipItem(0, {from: alice})
    //     const tx = await instance.receiveItem(0, {from: bob})
        
    //     if (tx.logs[0].event == "LogReceived") {
    //         eventEmitted = true
    //     }

    //     assert.equal(eventEmitted, true, 'adding an item should emit a Shipped event')
    // })

})