# MUK_docbook add-on Oxygen framework

**MUK_docbook** is an add-on Oxygen framework for use by prospective speakers and paper writers for the Markup UK conference.

## Installation

Follow the instructions in the oXygen manual at https://www.oxygenxml.com/doc/ug-editor/topics/installing-and-updating-add-ons.html

The **MUK_docbook** update site URL is https://github.com/MarkupUK/paperFramework/raw/master/updateSite.xml

Note that oXygen will require you to restart the editor after installing the add-on framework.

## 'Markup UK Paper' Transformation Scenario

The 'Markup UK Paper' transformation scenario makes it easy to preview how your paper will look in the Markup UK proceedings. The transformation scenario formats your paper using the same DocBook XSLT Stylesheets customisation as is used in the final proceedings.

The Markup UK proceedings are formatted using Antenna House Formatter. Accurate reproduction of the final proceedings requires that you also have a recent version of the Antenna House XSL Formatter installed and that Oxygen is configured to use it.

### 'Antenna House' external FO processor

The transformation scenario expects Oxygen to have an 'Antenna House' FO processor configuration that runs the Antenna House command-line formatter.

If your Oxygen is not already configured:

1. Oxygen will overwrite your current FO processor configuration in the following steps, so if desired, backup your current Oxygen global options by exporting them to a file.
1. Install AH Formatter V7.1 then restart Oxygen.
1. Download https://github.com/MarkupUK/paperFramework/raw/master/resources/formatter-options/formatter-options.xml
1. In Oxygen, under the **Options** menu, select **Import Global Options...**.
1. Select the `formatter-options.xml` file that you downloaded then click on **Open**.
1. When the **Import Global Options** dialog box is displayed, click on **Open**.
1. Oxygen will advise that a restart is required, but the FO processor configuration has been made already.

## License

Copyright [2018] [Markup UK]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
