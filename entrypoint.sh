# #!/bin/sh

# # Use TN_SIZE from environment variable, default to 150 if not set
# SIZE=${TN_SIZE:-150}

# # Process all image files in /pics directory
# for file in /pics/*; do
#     if [ -f "$file" ]; then
#         echo "Processing: $file with size: $SIZE"
#         ./thumbnail.sh "$file" "$SIZE"
#     fi
# done
#!/bin/sh
set -x  # לדיבוג מורחב

# בדיקת הסביבה
echo "Starting container with:"
echo "User: $(id)"
echo "Working directory: $(pwd)"
echo "Contents of /pics:"
ls -la /pics

# הגדרת גודל
SIZE=${TN_SIZE:-150}
echo "Using thumbnail size: $SIZE"

# עיבוד הקבצים
for file in /pics/*; do
    if [ -f "$file" ]; then
        echo "Processing: $file with size: $SIZE"
        ./thumbnail.sh "$file" "$SIZE"
        RESULT=$?
        if [ $RESULT -ne 0 ]; then
            echo "Error processing $file (exit code: $RESULT)"
        else
            echo "Successfully processed $file"
        fi
    fi
done

echo "Final contents of /pics:"
ls -la /pics