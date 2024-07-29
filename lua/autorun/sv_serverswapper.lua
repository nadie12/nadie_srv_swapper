util.AddNetworkString("SRVSWAPPER.BROADCASTMESSAGE")

local function BroadcastMessage(len, ply)
    PrintMessage(HUD_PRINTTALK)
end

net.Receive("SRVSWAPPER.BROADCASTMESSAGE", BroadcastMessage)