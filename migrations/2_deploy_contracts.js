var SupportLib = artifacts.require("SupportLib");
var MainContract = artifacts.require("MainContract");


module.exports = function(deployer){
    deployer.deploy(SupportLib)
    deployer.link(SupportLib, MainContract)
    deployer.deploy(MainContract)

};