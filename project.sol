// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FeedbackRewards {
    address public owner;
    uint256 public rewardAmount;
    mapping(address => bool) public hasProvidedFeedback;
    mapping(address => uint256) public rewards;

    event FeedbackGiven(address indexed student, string feedback);
    event RewardIssued(address indexed student, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(uint256 _rewardAmount) {
        owner = msg.sender;
        rewardAmount = _rewardAmount;
    }

    function giveFeedback(string calldata feedback) external {
        require(!hasProvidedFeedback[msg.sender], "Feedback already submitted");
        require(bytes(feedback).length > 0, "Feedback cannot be empty");

        hasProvidedFeedback[msg.sender] = true;
        rewards[msg.sender] += rewardAmount;

        emit FeedbackGiven(msg.sender, feedback);
        emit RewardIssued(msg.sender, rewardAmount);
    }

    function setRewardAmount(uint256 _newRewardAmount) external onlyOwner {
        rewardAmount = _newRewardAmount;
    }

    function claimReward() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");

        rewards[msg.sender] = 0;
        
        payable(msg.sender).transfer(reward);
    }

    function depositFunds() external payable onlyOwner {}

    function withdrawFunds(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(owner).transfer(amount);
    }

    receive() external payable {}
}
