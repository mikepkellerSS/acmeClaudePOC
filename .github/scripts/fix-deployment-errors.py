#!/usr/bin/env python3
  import json
  import sys
  import os
  import base64
  from anthropic import Anthropic

  def fix_deployment_errors(error_file):
      # Read deployment errors
      with open(error_file, 'r') as f:
          deploy_result = json.load(f)

      if deploy_result.get('status') == 0:
          return True  # No errors

      # Extract error messages
      errors = []
      if 'result' in deploy_result:
          for error in deploy_result['result'].get('details', {}).get('componentFailures', []):
              errors.append(f"{error['fullName']}: {error['problemType']} - {error['problem']}")

      # Read current code
      code_files = {}
      for root, dirs, files in os.walk('force-app'):
          for file in files:
              if file.endswith('.cls') or file.endswith('.trigger'):
                  filepath = os.path.join(root, file)
                  with open(filepath, 'r') as f:
                      code_files[filepath] = f.read()

      # Ask Claude to fix the errors
      client = Anthropic(api_key=os.environ['ANTHROPIC_API_KEY'])

      prompt = f"""
      Fix these Salesforce deployment errors:
      
      Errors:
      {chr(10).join(errors)}
      
      Current code files:
      {json.dumps(code_files, indent=2)}
      
      Provide the corrected code for each file that needs changes.
      Format: 
      FILE: <filepath>
      ```apex
      <corrected code>
      ```
      """

      response = client.messages.create(
          model="claude-3-haiku-20240307",
          max_tokens=4000,
          messages=[{"role": "user", "content": prompt}]
      )

      # Parse response and update files
      content = response.content[0].text
      current_file = None
      current_code = []
      in_code_block = False

      for line in content.split('\n'):
          if line.startswith('FILE:'):
              if current_file and current_code:
                  # Save previous file
                  with open(current_file, 'w') as f:
                      f.write('\n'.join(current_code))
              current_file = line.replace('FILE:', '').strip()
              current_code = []
              in_code_block = False
          elif line.strip() == '```apex':
              in_code_block = True
          elif line.strip() == '```':
              in_code_block = False
          elif in_code_block:
              current_code.append(line)

      # Save last file
      if current_file and current_code:
          with open(current_file, 'w') as f:
              f.write('\n'.join(current_code))

      return True

  if __name__ == '__main__':
      fix_deployment_errors(sys.argv[1])
