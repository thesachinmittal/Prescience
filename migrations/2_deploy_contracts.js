var SupportLib = artifacts.require("SupportLib");
var IncentiveEvaluation = artifacts.require("IncentiveEvaluation");
var FreeEvaluation = artifacts.require("FreeEvaluation");
var Main = artifacts.require("Main");


module.exports = function(deployer){
    deployer.deploy(SupportLib)
    deployer.link(SupportLib, IncentiveEvaluation)
    deployer.link(SupportLib, FreeEvaluation)
    deployer.deploy(Main)

};