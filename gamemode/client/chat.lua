
net.Receive("GM:ChatPrint",function()
	chat.AddText(unpack(net.ReadTable()))
end)