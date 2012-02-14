--
--   A* Lua ʵ��
--   By Jian
--   Version 1.0
--

-- ���� --

KMapWidth =  28              -- ��ͼ�Ŀ�ȣ��ڵ�����
KMapHeight =  32             -- ��ͼ�ĸ߶ȣ��ڵ�����





--[[

 ��ͼ�ڵ�
]]
CMapNode =
{
 iX = 0 ,                 -- �ڵ�ͼ�е� X ����
 iY = 0 ,                 -- �ڵ�ͼ�е� Y ����
 iIndex = 0 ,             -- ��һά��ͼ�����е��±�

 iFCost = 0 ,             -- A Star �㷨�е� F �ķ�
 -- iGCost = 0 ,             -- A Star �㷨�е� G �ķ�
 -- iHCost = 0 ,             -- A Star �㷨�е� H �ķ�

 iIsInOpenList = false ,  -- �ýڵ��Ƿ��� �����б� ��
 iIsInCloseList = false , -- �ýڵ��Ƿ��� �ر��б� ��

iParent = nil ,          -- ʹ��A Star ��·�������д洢���ڵ�
iNext = nil ,            -- ��openList �� closeList ��ָ����һ��Ԫ��

iCanPass = true          -- �ýڵ��Ƿ��ǿ�ͨ���ڵ�
}

-- ���캯�� --
function CMapNode:new( aIndex )

if ( aIndex == nil ) then
  error( " the Index Can't be nil " ) end

ret = object or {}
 self.__index = self
setmetatable(ret, self)
-- ######## Line too long (106 chars) ######## :
ret.iX = aIndex - math.floor( aIndex / KMapWidth) * KMapWidth  -- ���ࡢδ֪ % Ϊʲô������ѧ��Ҳ����
ret.iY = ( aIndex - ret.iX ) / KMapWidth    -- Lua �ó������Ǹ�����
ret.iIndex = aIndex
return ret
end


-- ���ƺ��� --
function CMapNode:DrawChar()

drawChar = nil

if ( self.iCanPass ) then
 if ( self.iIsInOpenList ) then drawChar = "1 "
 else drawChar = "�� " end
else drawChar = "��" end

return drawChar

end

-- ���Ʊ�
drawMap = { n = KMapWidth *  KMapHeight }

-- ��ʼ����ͼ�� --
Map = { n = KMapWidth *  KMapHeight }
for x = 0 , Map.n - 1 do
 Map[x] = CMapNode:new( x )
end

--[[

 ��ͼ��
]]


--���ƺ��� --
function Map:Draw()
 local drawString = ""
 for x = 0 , KMapWidth *  KMapHeight do
  if ( self[x].iX == 0 ) then
   print( "\n")
   print( drawString )
   drawString = ""
    end -- end if

    drawString = drawString .. self[x]:DrawChar()
end -- end for
end


--[[

��ͼ�ڵ��б�����ṹ��
]]

NodeList =
{
iRoot = nil        -- ���ڵ�
}

-- ���캯�� --
function NodeList:new()
ret = {}
 self.__index = self
setmetatable(ret, self)
return ret
end

-- ��������
function NodeList:Clear()
	self.iRoot = nil
end

-- ����һ��Node���б� --

function NodeList:AddNode( aMapNode )

 if ( self.iRoot == nil )then
   self.iRoot = aMapNode
   return
 end

 -- �ҳ���һ�� iFCost �������Node����������ǰ��
local curNode = self.iRoot    -- ��ǰ�ڵ�
local lastNode = nil          -- ǰһ�ڵ�
 while ( curNode )  do
  if ( curNode.iFCost >= aMapNode.iFCost ) then
 aMapNode.iNext = curNode
 if( curNode == self.iRoot ) then self.iRoot = aMapNode
 else lastNode.iNext = aMapNode  end

 return
  end -- end if
lastNode = curNode
curNode = curNode.iNext
 end -- end while

 lastNode.iNext = aMapNode

end

-- ���б���ɾ��һ��Node --
function NodeList:DeleteNode( aMapNode )

local curNode = self.iRoot    -- ��ǰ�ڵ�
local lastNode = nil          -- ǰһ�ڵ�

while ( curNode ) do
  if ( curNode == aMapNode ) then
    if ( lastNode ) then lastNode.iNext = aMapNode.iNext end
    if ( curNode == self.iRoot ) then self.iRoot = self.iRoot.iNext end
 aMapNode.iNext = nil
    return
  end
lastNode = curNode
curNode = curNode.iNext
end -- end while

error( "The Node you deleted is not in the list !")
end

-- �����б�
openList = NodeList:new()

-- ���һ��Node�������б�
function openList:Add( aMapNode )
 aMapNode.iIsInOpenList = true
 self:AddNode( aMapNode )
end

-- �ӿ����б����Ƴ�һ��Node
function openList:Remove( aMapNode )
 aMapNode.iIsInOpenList = false
 self:DeleteNode( aMapNode )
end


-- �ر��б�
closeList = NodeList:new()

-- ���һ��Node���ر��б�
function closeList:Add( aMapNode )
 aMapNode.iIsInCloseList = true
 self:AddNode( aMapNode )
end

--[[

A Star Ѱ·������
]]
function AStarInit()
    --print(" AStarInit() ")
	openList:Clear()
	closeList:Clear()
	-- ��ʼ����ͼ�� --
	for x = 0 , Map.n - 1 do
	Map[x].iIsInOpenList = false   -- �ýڵ��Ƿ��� �����б� ��
	Map[x].iIsInCloseList = false  -- �ýڵ��Ƿ��� �����б� ��
	Map[x].iParent = nil
	Map[x].iNext = nil
	end

end
function AStarPathFind( aStartIndex, aEndIndex )

	print(string.format("AStarPathFind(%d,%d)",aStartIndex,aEndIndex))
-- ######## Line too long (94 chars) ######## :
  if ( aStartIndex < 0 and aStartIndex > Map.n ) then error( "StartIndex Out Off bound ")  end
-- ######## Line too long (88 chars) ######## :
  if ( aEndIndex < 0 and aEndIndex > Map.n ) then error( "EndIndex Out Off bound ")  end

-- ���Ȱ���ʼ�ڵ���ӵ������б�
local H = HDistance( aStartIndex , aEndIndex )
local G = 1
Map[aStartIndex].iFCost = H + G

openList:AddNode( Map[aStartIndex] )

while ( true ) do

 -- ȡ��openList�е�F����ֵ
 -- ���ж�openList�Ƿ�Ϊ��
 leaseFNode = openList.iRoot
 if ( leaseFNode == nil ) then break end

 -- �ӿ����б����Ƴ��ýڵ�
 openList:Remove( leaseFNode )

  -- ��ӵ��ر��б�
 closeList:Add( leaseFNode )

 -- �Ѹýڵ㸽���Ľڵ���ӵ� �����б�
 -- �����ݺ�������ֵ�ж��Ƿ��Ѿ��ҵ�·��
 if ( AddNeighborToOpenList( leaseFNode, aEndIndex ) ) then break  end


end -- end while

end

-- ��ȡH ����ֵ
function HDistance( aStartIndex, aEndIndex )

local tmp1 = math.abs(Map[aStartIndex].iX - Map[aEndIndex].iX)
local tmp2 = math.abs(Map[aStartIndex].iY - Map[aEndIndex].iY)

--local tmp1 = Map[aStartIndex].iX - Map[aEndIndex].iX
--local tmp2 = Map[aStartIndex].iY - Map[aEndIndex].iY
--
--if ( tmp1 <= 0 ) then tmp1 = -tmp1 end
--if ( tmp2 <= 0 ) then tmp2 = -tmp2 end

return ( ( tmp1^2 + tmp2^2 )^0.5 )
end


-- ��ָ���ڵ㸽���Ľڵ���ӵ� �����б�
-- �����Ƿ��Ѿ�����Ŀ��ڵ�
function AddNeighborToOpenList( aMapNode, aEndIndex )

ret = false   -- ����ֵ

local tmpNode = nil
local aIndex = nil

for aY = aMapNode.iY-1, aMapNode.iY+1  do
 for aX = aMapNode.iX-1, aMapNode.iX+1  do

 -- �߽���
 if ( aX >= 0 and aX < KMapWidth and aY >= 0 and aY < KMapHeight ) then

  aIndex = aX + aY * KMapWidth
  tmpNode = Map[aIndex]

  -- �ж��Ƿ��ǽ����ڵ�
  if ( aIndex == aEndIndex ) then
  ret = true
  tmpNode.iParent = aMapNode
  break
 end
 if tmpNode == nil then
	print(string.format("ERROR:tempNode(%d) is nil!",aIndex))
 end
 -- �жϸýڵ��Ƿ��ͨ��
 if ( tmpNode.iCanPass ) then
    -- �Ƿ��Ѿ��ڹر��б���
  if ( tmpNode.iIsInCloseList == false ) then
	   local H = HDistance( tmpNode.iIndex , aEndIndex )
	   local G = 1     -- �򵥵Ķ�Ϊ1
	   local F = H + G

	   -- �Ƿ��ڿ����б���
	   if ( tmpNode.iIsInOpenList == true ) then
	     -- �ж��Ƿ����ڵ�·������
	     if( F < tmpNode.iFCost ) then
	     tmpNode.iFCost = F
	   tmpNode.iParent = aMapNode
	     end

	   else
	    tmpNode.iFCost = F
	    tmpNode.iParent = aMapNode

	   -- ��ӵ������б���
	   openList:Add( tmpNode )
	   end  -- end �Ƿ��ڿ����б���

  end   -- end �Ƿ��Ѿ��ڹر��б���
 end  -- end �жϸýڵ��Ƿ��ͨ��

 end -- end �߽���

 end -- end for
end -- end for

return ret

end

function setblock(i)

 if(i == 0) then
	 for x = 30, 37 do
	   Map[x].iCanPass = false
	   drawMap[x] = 1
	 end
 else

	 for x = 65 , 77 do
	   Map[x].iCanPass = false
	   drawMap[x] = 1
	 end
 end
end

function AStarDrawPath(endIndex)
 node = Map[endIndex]

 while( node.iParent ) do
   drawMap[node.iIndex] = 2
   node = node.iParent
 end
  -- ����
 local drawString = ""
 for x = 0 , drawMap.n - 1 do

    if ( Map[x].iX == 0 ) then
    print( drawString )
    drawString = ""
    end -- end if

    if ( drawMap[x] == 1 ) then
      drawString = drawString .. "��"     -- ������ͨ�е�
    elseif ( drawMap[x] == 2 )  then
      drawString = drawString .. "��"     -- �����ҵ���·����
    else
      drawString = drawString .. "��"     -- ������ͨ�е�
    end
 end
 end
--[[

Test main����
]]
function main()

 startIndex = 0
 endIndex = 214

 -- ���Ʊ�
 drawMap = { n = KMapWidth *  KMapHeight }



 local x = os.clock()
 --print(" Path Finding ")

 local l = 2
 for i=1,l do
 AStarInit()
 setblock(i-1)
 --setblock(1)
 AStarPathFind( startIndex , endIndex )
 -- AStarOutString()

 end
 --print(" Path Finding done , loop  " .. l)
 --print(string.format("elapsed time: %.6f\n", os.clock() - x))
-- local closeNode = closeList.iRoot
--
-- local closeNodeCount = 0
-- while( closeNode ) do
--   print( closeNode.iIndex )
--   closeNode = closeNode.iNext
--   closeNodeCount = closeNodeCount + 1
-- end
--
-- print( "closeNodeCount is" , closeNodeCount )
end

--main()
