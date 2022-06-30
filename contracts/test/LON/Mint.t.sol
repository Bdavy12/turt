// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import "contracts-test/LON/Setup.t.sol";

contract TestLONMint is TestLON {
    // include Snapshot struct from BalanceSnapshot
    using BalanceSnapshot for BalanceSnapshot.Snapshot;

    function testCannotMintByNotMinter() public {
        vm.expectRevert("not minter");
        vm.prank(user);
        lon.mint(user, 1e18);
    }

    function testCannotMintExceedCap() public {
        uint256 excessAmount = lon.cap() + 1;
        vm.expectRevert("cap exceeded");
        lon.mint(user, excessAmount);
    }

    function testCannotMintToZeroAddress() public {
        vm.expectRevert("zero address");
        lon.mint(address(0), 1e18);
    }

    function testMint() public {
        BalanceSnapshot.Snapshot memory userLon = BalanceSnapshot.take(user, address(lon));
        lon.mint(user, 1e18);
        userLon.assertChange(int256(1e18));
    }
}
