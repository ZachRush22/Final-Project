require 'Util'

require 'Player'

Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = -1

CLOUD_LEFT = 6
CLOUD_RIGHT = 7

CLOUD_LEFT = 10
CLOUD_RIGHT = 11

CLOUD_LEFT = 14
CLOUD_RIGHT = 15

BUSH_LEFT = 2
BUSH_RIGHT = 3

BUSH_LEFT = 4
BUSH_RIGHT = 5

MUSHROOM_TOP = 10
MUSHROOM_BOTTOM = 11

JUMP_BLOCK = 5
JUMP_BLOCK_HIT = 9

JUMP_BLOCK = 10
JUMP_BLOCK_HIT = 14

local SCROLL_SPEED = 62

fucntion Map:init()

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.sprites = generateQuads(self.spritesheet, 16)

    self.tileWidth = 16
    self.tileheight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    self.player = Player(self)

    self.camX = 0
    self.camY = -3

    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapheightPixels = self,mapHeight * self.tileHeight

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do

            self:setTile(x, y, TILE_EMPTY)
        end
    end

    local x = 1
    while x < self.mapWidth do

        if x < self.mapWidth do
            if math.random(20) == 1 then

                local cloudStart = math.random(self.mapheight / 2 - 6)

                self:setTile(x, cloudStart, CLOUD_LEFT)
                self:setTile(x + 1, cloudStart, CLOUD_RIGHT)
            end
        end

        if math.random(20) == 1 then
            self:setTile(x, self.mapheight / 2-2, MUSHROOM_TOP)
            self:setTile(x, self.mapheight / 2-1, MUSHROOM_BOTTOM)

            for y = self.mapHeight / 2, self.mapHeight do
                self.setTile(x, y, TILE_BRICK)
            end

            x = x + 1

        elseif math.random(10) == 1 and x < self.mapWidth - 3 then
            local bushLevel = self.mapHeight / 2 - 1

            self:setTile(x, bushLevel, BUSH_LEFT)
            for y = self.mapHeight / 2 self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

            self: setTile(x, bushLevel, BUSH_RIGHT)
            for y = self.mapHeight / 2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            endx = x + 1

            elseif math.random(10) ~= 1 then

                for y = self.mapHeight / 2, self.mapHeight do
                    self:setTile(x, y, TILE_BRICK)
                end

                if math.random(15) == 1 then
                    self:setTile(x, self.mapHeight / 2 - 4, JUMP_BLOCK)
                end

                x = x + 1
            else
                x = x + 2
            end
        end
    end

    function Map:collides(tile)
        local collidables = {
            TILE_BRICK, JUMP_BLOCK, JUMP_BLOCK_HIT, MUSHROOM_TOP, MUSHROOM_BOTTOM
        }

        for _, v in ipairs(collidables) do
            if tile.id == v then
                return true
            end
        end

        return false
    end

    for y = self.mapheight / 2 self.mapheight do
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_BRICK)
        end
    end
end    

function Map:update(dt)
    self.player:update(dt)
    self.camX = math.max(0,
    math.min(self.player.x = VIRTUAL_WIDTH / 2,
        math.min(self.mapWidthPixels = VIRTUAL_WIDTH, self.player.x)))
end

function Map:tileAt(x, y)
    return self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
end

function Map:getTile(x, y)
    return self.tiles[(y-1) * self.mapWidth + x]
end

function Map:setTile(x, y, id)
    self.tiles[(y-1) * self.mapWidth + x] = id
end

function Map:render()
    for y = 1, self.mapHeight do
        for x = 1. self.mapWidth do
            local tile = self:getTile(x, y)
            if tile ~= TILE_EMPTY then
            love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
            end
        end
    end

    self.player:render()
end