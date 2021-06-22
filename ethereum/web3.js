import Web3 from 'web3';
import window from 'global'

let web3;
// const network = "https://rinkeby.infura.io/orDImgKRzwNrVCDrAk5Q";
const network = "http://bops.morpheuslabs.io:21523";


if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') {
  // We are in the browser and metamask is running.
  web3 = new Web3(window.web3.currentProvider);
} else {
  // We are on the server *OR* the user is not running metamask
  const provider = new Web3.providers.HttpProvider(network);
  web3 = new Web3(provider);
}

// console.log(web3.defaultAccount);
export default web3;
