#!/bin/bash

echo "=== Blog-Kit Session Resume ==="
echo "Recent Activity (from archive):"
ls -lt archive | head -n 5

echo ""
echo "Current TODO (Active):"
grep "\- \[ \]" TODO.md | head -n 5

echo ""
echo "Last Published:"
ls -d archive/published* 2>/dev/null | tail -n 1

echo ""
echo "Roadmap Status:"
grep "##" blog_toolkit_roadmap.md | head -n 5
