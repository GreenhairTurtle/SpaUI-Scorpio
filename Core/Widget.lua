Scorpio "SpaUI.Widget" ""

namespace "SpaUI.Widget"

-- 没有视图回收功能的ListFrame
-- 支持多布局
-- TODO
__Sealed__()
class "ListFrame" (function(_ENV)
    inherit "FauxScrollFrame"
    
    -- 方向
    property "Orientation" { type = Orientation, default = Orientation.VERTICAL}

    -- 数据源
    property "Data" { type = Table + List }

    -- Item数目
    -- 这个函数被调用时会传入 Data，需要返回Integer
    property "GetItemCount" { type = Function }

    -- Item类型
    -- 这个函数被调用时会传入 Data及 position，需要返回Integer
    property "GetItemType" { type = Function, default = function(data, position) return 0 end }

    -- Item创建回调
    -- 这个函数被调用时会传入 ListFrame.ScrollChild、ItemType，需要返回一个Frame
    -- Frame的锚点会被清除，请注意
    -- 不要对返回的Frame做Style！
    property "OnItemCreate" { type = Function }

    -- 数据绑定
    -- 这个函数被调用时会传入ItemFrame、Data及position
    property "OnBindData" { type = Function, default = function(itemFrame, data, position) end}

    -- 获取Item的间距
    -- Item是根据Orientation顺序排列，由此函数返回值控制间距
    -- 这个函数被调用时会传入 ItemType
    -- 需要返回四个参数 left top right bottom
    property "GetItemMargin" { 
        type            = Funtion,
        default         = function(itemType)
            return 0, 0, 0, 0
        end
    }

    local function removeAllItems(self)
        local items = self.__Items or {}
        local cache = self.__Cache or {}
        for itemType, category in pairs(items) do
            cache[itemType] = cache[itemType] or {}
            for _, item in ipairs(category) do
                item:Hide()
                tinsert(cache[itemType], item)
            end
        end
        self.__Cache = cache
        self.__Items = items
    end

    local function setItemLocation(self, item, preItem, itemType)
        local left, top, right, bottom = self.GetItemMargin(itemType)
        local orientation = self.orientation
        preItem = preItem or self:GetChild("ScrollChild")

        local xOffset, yOffset, point, relativePoint

        if orientation == Orientation.VERTICAL then
            xOffset = math.abs(left)
            yOffset = math.abs()
        else

        end
    end

    local function createOrRefreshItems(self)
        local cache = self.__Cache or {}
        local items = self.__Items or {}
        local count = self.GetItemCount(self.Data)
        local preItem
        for i = 1, count do
            local itemType = self.GetItemType(self.Data, i)
            items[itemType] = items[itemType] or {}
            local item = cache[itemType] and tremove(cache[itemType]) or nil
            if not item then
                item = self.OnItemCreate(self:GetChild("ScrollChild"), itemType)
                item:ClearAllPoints()
                tinsert(items[itemType], item)
            end
            setItemLocation(self, item, preItem, itemType)

            preItem = item
        end
    end

    function Refresh(self)
        removeAllItems(self)
        createOrRefreshItems(self)
    end
end)