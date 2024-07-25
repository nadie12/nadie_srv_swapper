--[[

    IMPLEMENTS A UI TO EASILY SWAP BETWEEN THE MAIN AND EVENT SERVER.
    CONTEXT MENU POPUP

    Made by Nadie (v1.1) Git incorporated

    Garry's Mod Github integration by Phatso on Discord 😁
    https://github.com/CFC-Servers/wisp_addon_manager       

--]]
 

 
--  Derma Blur Methodt

local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(color_white)
    surface.SetMaterial(blur)

    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

surface.CreateFont("NADIE.LABEL", {
    font = "Arial",
    antialias = true,
    extended = true,
    weight = 500,
    size = ScrW() * 0.009,
})

local COL_1 = Color(40, 40, 40, 100)
local COL_2 = Color(40, 40, 40, 150)
local COL_3 = Color(100, 186, 100, 150) -- Green color for the "Connect?" state
local COL_4 = Color(100, 100, 100, 150) -- Grey color for the disabled state
local COL_5 = Color(148,148,148)

local MAIN_SERVER_IP = "45.62.160.93:27047"
local EVENT_SERVER_IP = "45.62.160.68:27068"

local NSS_PANEL

function NSS_Open()
    local w, h = ScrW(), ScrH()

    if IsValid(NSS_PANEL) then
        NSS_PANEL:Remove()
    end

    local PANEL = vgui.Create("DFrame")
    PANEL:SetParent(g_ContextMenu)
    PANEL:SetSize(w * 0.08, w * 0.06)
    PANEL:SetPos(w, h * 0.45)
    PANEL:MoveTo(w * .92, h * 0.45, 0.1, 0, -1, function() end)
    PANEL:SetTitle("")
    PANEL:SetMouseInputEnabled(true)
    PANEL.Paint = function(self, w, h)
        DrawBlur(self, 6)

        draw.RoundedBoxEx(5, 0, 0, w, h, COL_1, true, false, false, false)

        draw.SimpleText("Servers", "NADIE.LABEL", w * 0.5, h * 0.11, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Adjusted title position
    end

    local w, h = PANEL:GetSize()

    local MAIN_SRV = PANEL:Add("DButton") 
    MAIN_SRV:DockMargin(0, 0, 0, 0)
    MAIN_SRV:Dock(TOP)
    MAIN_SRV:SetSize(w, h * 0.33)
    MAIN_SRV:SetText("")
    MAIN_SRV.Paint = function(s, w, h)
        surface.SetDrawColor(Color(100, 100, 100, 100))
        surface.DrawOutlinedRect(0, 0, w, h)

        if s.ConfirmConnect then
            draw.RoundedBox(0, 0, 0, w, h, COL_3)
            draw.SimpleText("Confirm Connect?", "NADIE.LABEL", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif game.GetIPAddress() == MAIN_SERVER_IP then
            draw.RoundedBox(0, 0, 0, w, h, COL_4)
            draw.SimpleText("ImperialRP: Main", "NADIE.LABEL", w * 0.5, h * 0.5, COL_5, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.RoundedBox(0, 0, 0, w, h, COL_2)
            draw.SimpleText("ImperialRP: Main", "NADIE.LABEL", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local EVENT_SRV = PANEL:Add("DButton") 
    EVENT_SRV:DockMargin(0, 1, 0, 0)
    EVENT_SRV:Dock(TOP)
    EVENT_SRV:SetSize(w, h * 0.33)
    EVENT_SRV:SetText("")
    EVENT_SRV.Paint = function(s, w, h)
        surface.SetDrawColor(Color(100, 100, 100, 100))
        surface.DrawOutlinedRect(0, 0, w, h)

        if s.ConfirmConnect then
            draw.RoundedBox(0, 0, 0, w, h, COL_3)
            draw.SimpleText("Confirm Connect?", "NADIE.LABEL", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif game.GetIPAddress() == EVENT_SERVER_IP then
            draw.RoundedBox(0, 0, 0, w, h, COL_4)
            draw.SimpleText("ImperialRP: Event", "NADIE.LABEL", w * 0.5, h * 0.5, COL_5, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.RoundedBox(0, 0, 0, w, h, COL_2)
            draw.SimpleText("ImperialRP: Event", "NADIE.LABEL", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    MAIN_SRV.DoClick = function(s)
        if game.GetIPAddress() ~= MAIN_SERVER_IP then
            if not s.ConfirmConnect then
                s.ConfirmConnect = true
                timer.Simple(5, function()
                    if IsValid(s) then
                        s.ConfirmConnect = false
                    end
                end)
            else
                RunConsoleCommand("connect", MAIN_SERVER_IP)
            end
        end
    end

    EVENT_SRV.DoClick = function(s)
        if game.GetIPAddress() ~= EVENT_SERVER_IP then
            if not s.ConfirmConnect then
                s.ConfirmConnect = true
                timer.Simple(5, function()
                    if IsValid(s) then
                        s.ConfirmConnect = false
                    end
                end)
            else
                RunConsoleCommand("connect", EVENT_SERVER_IP)
            end
        end
    end

    MAIN_SRV.OnCursorEntered = function(s)
        if game.GetIPAddress() == MAIN_SERVER_IP then
            s:SetCursor("arrow")
        else
            s:SetCursor("hand")
        end
    end

    EVENT_SRV.OnCursorEntered = function(s)
        if game.GetIPAddress() == EVENT_SERVER_IP then
            s:SetCursor("arrow")
        else
            s:SetCursor("hand")
        end
    end

    NSS_PANEL = PANEL

    return PANEL
end

hook.Add("OnContextMenuOpen", "NSS.ContextMenuOpen", function()
    local PANEL = NSS_Open()
    if !IsValid(PANEL) then
        return
    end

    PANEL:ShowCloseButton(false)
end)



MsgC(Color(0, 255, 0), "\n\n\n" .. [[


███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗                              
██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗                             
███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝                             
╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗                             
███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║                             
╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝                             
                                                                              
                    ███████╗██╗    ██╗ █████╗ ██████╗ ██████╗ ███████╗██████╗ 
                    ██╔════╝██║    ██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
                    ███████╗██║ █╗ ██║███████║██████╔╝██████╔╝█████╗  ██████╔╝
                    ╚════██║██║███╗██║██╔══██║██╔═══╝ ██╔═══╝ ██╔══╝  ██╔══██╗
                    ███████║╚███╔███╔╝██║  ██║██║     ██║     ███████╗██║  ██║
                    ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝
                                                                                                                             
                                    Loaded Successfully!                                                                     

]] .. "\n\n\n")