
![SC-KillTracker-ICON](https://github.com/user-attachments/assets/44dd4a77-fbd9-4343-b8f9-9aedea19ffb5)

SC-KillTracker is a simple, Open-Source, powershell script wrapped as an exe. It looks at the Game.log file in the Star Citizen folder and parses lines that indicate a player died. The script generates report with player names of the Killer, Killed, Weapon, Damage Type and Zone.

![image](https://github.com/user-attachments/assets/0b73ce51-a944-40ed-8044-a3d23aed4006)

Currently working to implement in-game overlay. This can be achieved with the v0.10 build that utilizes Windows 'Toast' notifications. Windows settings will need to be adjusted to allow this and there could be unintended notifications that are allowed as a result. I'll be working to figure out how to allow the powershell specific notifications to avoid that.

![image](https://github.com/user-attachments/assets/35fed758-beaa-4031-9a55-6e23185b7d8b)

In windows open Settings > System > Notifications.
Make sure windows notification slider is On

![image](https://github.com/user-attachments/assets/b695de9d-26d4-4fce-b826-89e48cf66714)

Turn off Allow notifications to play sounds, if desired.

Scroll down to "Turn on do not disturb automatically"
Uncheck "When playing a game"
![image](https://github.com/user-attachments/assets/3d67942d-a42f-4d55-80ba-f23d8d629c7b)
