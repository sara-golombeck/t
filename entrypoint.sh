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

# הגדרת משתני סביבה
SIZE=${TN_SIZE:-150}
echo "Starting thumbnail generation with size: $SIZE"

# בדיקת סביבת העבודה
echo "Environment check:"
echo "Current directory: $(pwd)"
echo "Contents of /pics before processing:"
ls -la /pics

# בדיקת הרשאות
if [ ! -w "/pics" ]; then
    echo "Error: No write permissions in /pics directory"
    exit 1
fi

# עיבוד הקבצים
for file in /pics/*; do
    if [ -f "$file" ]; then
        echo "Processing: $file"
        
        # בדיקה אם הקובץ קריא
        if [ ! -r "$file" ]; then
            echo "Error: Cannot read file $file"
            continue
        }
        
        # הרצת הסקריפט thumbnail
        /app/thumbnail.sh "$file" "$SIZE"
        RESULT=$?
        
        # בדיקת תוצאת ההרצה
        if [ $RESULT -eq 0 ]; then
            echo "Successfully processed: $file"
        else
            echo "Error processing file: $file (Exit code: $RESULT)"
        fi
    fi
done

# בדיקה סופית
echo "Contents of /pics after processing:"
ls -la /pics

# בדיקת יצירת thumbnails
THUMBNAIL_COUNT=$(ls -1 /pics/*_thumb.jpg /pics/tn-*.png 2>/dev/null | wc -l)
echo "Number of thumbnails created: $THUMBNAIL_COUNT"

if [ $THUMBNAIL_COUNT -eq 0 ]; then
    echo "Warning: No thumbnails were created"
    exit 1
fi

echo "Thumbnail generation completed successfully"