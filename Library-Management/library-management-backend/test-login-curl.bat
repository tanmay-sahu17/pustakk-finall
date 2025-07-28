@echo off
echo Testing login API...
echo.

curl -X POST "http://165.22.208.62:5010/api/auth/login" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"simple\",\"password\":\"test123\"}"

echo.
echo.
echo Testing with id parameter...
echo.

curl -X POST "http://165.22.208.62:5010/api/auth/login" ^
  -H "Content-Type: application/json" ^
  -d "{\"id\":\"simple\",\"password\":\"test123\"}"

echo.
echo Done.
pause
