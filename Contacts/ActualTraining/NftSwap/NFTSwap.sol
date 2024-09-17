// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NFTSwap is IERC721Receiver, ReentrancyGuard {
    //挂单
    event List(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 price
    );
    //购买
    event Purchase(
        address indexed buyer,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 price
    );
    //撤单
    event Revoke(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId
    );
    //修改价格
    event Update(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 newPrice
    );

    struct Order {
        address owner;
        uint256 price;
    }
    //nft系列（合约地址）  tokenId => Order
    mapping(address => mapping(uint256 => Order)) public nftList;
    //用户使用ETF购买NFT，合约需要实现Fallback函数来接收ETH
    fallback() external payable {}
    receive() external payable {}

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    /**
     * 挂单： 卖家上架NFT,合约地为：_nftAddr,tokneId，价格为：以太坊（wei)
     * @param _nftAddr nft合约地址
     * @param _tokenId tokenId
     * @param _price 价格
     */
    function list(address _nftAddr, uint256 _tokenId, uint256 _price) public {
        IERC721 _nft = IERC721(_nftAddr);
        //确保合约得到授权
        require(
            _nft.getApproved(_tokenId) == address(this) ||
                _nft.isApprovedForAll(msg.sender, address(this)),
            "Contract is not approved"
        );
        require(_price > 0, "price must > 0");

        //设置nf持有人和价格
        Order storage _order = nftList[_nftAddr][_tokenId];
        _order.owner = msg.sender;
        _order.price = _price;

        //将nft转账到合约
        _nft.safeTransferFrom(msg.sender, address(this), _tokenId);

        //释放事件
        emit List(msg.sender, _nftAddr, _tokenId, _price);
    }

    /**
     * 撤单：卖家取消挂单
     * @param _nftAddr nft合约地址
     * @param _tokneId tokenid
     */
    function revoke(address _nftAddr, uint256 _tokneId) public {
        //取得order
        Order storage _order = nftList[_nftAddr][_tokneId];
        //必须持有人发起
        require(_order.owner == msg.sender, "not owner");
        //声明IERC721接口合约变量
        IERC721 _nft = IERC721(_nftAddr);
        //NFT是否在合约中
        require(_nft.ownerOf(_tokneId) == address(this), "Invalid Order");
        //将NFT转回给卖家
        _nft.safeTransferFrom(address(this), msg.sender, _tokneId);
        //删除Order
        delete nftList[_nftAddr][_tokneId];
        //释放事件
        emit Revoke(msg.sender, _nftAddr, _tokneId);
    }
    /**
     * 卖家调整价格
     * @param _nftAddr nft合约地址
     * @param _tokenId tokenId
     * @param _newPrice 价格
     */
    function update(
        address _nftAddr,
        uint256 _tokenId,
        uint256 _newPrice
    ) public {
        require(_newPrice > 0, "Invalied price !");
        Order storage _order = nftList[_nftAddr][_tokenId];
        //必须持有人发起
        require(_order.owner == msg.sender, "not owner");
        //声明IERC721接口合约变量
        IERC721 _nft = IERC721(_nftAddr);
        //nft是否在合约中
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order");
        //调增价格
        _order.price = _newPrice;
        //释放事件
        emit Update(msg.sender, _nftAddr, _tokenId, _newPrice);
    }

    /**
     * 买家购买nft,使用ETH
     * @param _nftAddr nft合约地址
     * @param _tokenId tokenId
     */
    function purchase(
        address _nftAddr,
        uint256 _tokenId
    ) public payable nonReentrant {
        //取得Order
        Order storage _order = nftList[_nftAddr][_tokenId];
        //nft价格大于0
        require(_order.price > 0, "Invalid Price");
        //购买价格大于标价
        require(_order.price <= msg.value, "Increase Price !");
        //声明IERC721接口合约变量
        IERC721 _nft = IERC721(_nftAddr);
        //NFT是否在合约中
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order");
        address seller = _order.owner;
        uint256 price = _order.price;
        //删除Order
        delete nftList[_nftAddr][_tokenId];
        //将nft转给买家
        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        //将ETH转给卖家，多余的ETH退回给买家
        payable(seller).transfer(price);
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
        //释放事件
        emit Purchase(msg.sender, _nftAddr, _tokenId, _order.price);
    }
}
