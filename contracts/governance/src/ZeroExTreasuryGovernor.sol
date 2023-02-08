// SPDX-License-Identifier: Apache-2.0
/*

  Copyright 2023 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/
pragma solidity ^0.8.17;

import "@openzeppelin/governance/Governor.sol";
import "@openzeppelin/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/governance/extensions/GovernorVotes.sol";

import "./IZeroExVotes.sol";

contract ZeroExTreasuryGovernor is Governor, GovernorSettings, GovernorCountingSimple, GovernorVotes {
    constructor(
        IVotes _token
    )
        Governor("ZeroExTreasuryGovernor")
        GovernorSettings(14400 /* 2 days */, 50400 /* 7 days */, 5e11)
        GovernorVotes(_token)
    {}

    function quorum(uint256 blockNumber) public pure override returns (uint256) {
        return 23e11;
    }

    // The following functions are overrides required by Solidity.

    function votingDelay() public view override(IGovernor, GovernorSettings) returns (uint256) {
        return super.votingDelay();
    }

    function votingPeriod() public view override(IGovernor, GovernorSettings) returns (uint256) {
        return super.votingPeriod();
    }

    function proposalThreshold() public view override(Governor, GovernorSettings) returns (uint256) {
        return super.proposalThreshold();
    }

    /**
     * Overwritten GovernorVotes implementation
     * Read the quadratic voting weight from the token's built in snapshot mechanism (see {Governor-_getVotes}).
     */
    function _getVotes(
        address account,
        uint256 blockNumber,
        bytes memory /*params*/
    ) internal view virtual override(Governor, GovernorVotes) returns (uint256) {
        return IZeroExVotes(address(token)).getPastQuadraticVotes(account, blockNumber);
    }
}
