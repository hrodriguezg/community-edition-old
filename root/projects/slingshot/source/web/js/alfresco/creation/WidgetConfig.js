/**
 * Copyright (C) 2005-2013 Alfresco Software Limited.
 *
 * This file is part of Alfresco
 *
 * Alfresco is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Alfresco is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Alfresco. If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * @module alfresco/creation/WidgetConfig
 * @extends dijit/_WidgetBase
 * @mixes dijit/_TemplatedMixin
 * @mixes module:alfresco/core/Core
 * @author Dave Draper
 */
define(["dojo/_base/declare",
        "dijit/_WidgetBase", 
        "dijit/_TemplatedMixin",
        "dojo/text!./templates/WidgetConfig.html",
        "alfresco/core/Core",
        "alfresco/forms/Form",
        "dojo/_base/lang",
        "dijit/registry",
        "dojo/_base/array",
        "dijit/form/Button",
        "dojo/dom-class"], 
        function(declare, _Widget, _Templated, template, AlfCore, Form, lang, registry, array, Button, domClass) {
   
   return declare([_Widget, _Templated, AlfCore], {
      
      /**
       * An array of the CSS files to use with this widget.
       * 
       * @instance
       * @type {Array}
       */
      cssRequirements: [{cssFile:"./css/WidgetConfig.css"}],
      
      /**
       * An array of the i18n files to use with this widget.
       * 
       * @instance
       * @type {Array}
       */
      i18nRequirements: [{i18nFile: "./i18n/WidgetConfig.properties"}],
      
      /**
       * The HTML template to use for the widget.
       * @instance
       * @type {String}
       */
      templateString: template,
      
      /**
       * This will need to be prefixed with a scope.
       * 
       * @instance
       * @type {string}
       * @default "ALF_CONFIGURE_WIDGET"
       */
      configTopic: "ALF_CONFIGURE_WIDGET",
      
      /**
       * Can be used to clear the currently displayed widget.
       * 
       * @instance
       * @type {string}
       * @default "ALF_CLEAR_CONFIGURE_WIDGET"
       */
      clearTopic: "ALF_CLEAR_CONFIGURE_WIDGET",

      /**
       * Can be used to clear the currently displayed widget.
       * 
       * @instance
       * @type {string}
       * @default "ALF_SAVE_CONFIGURE_WIDGET"
       */
      saveTopic: "ALF_SAVE_CONFIGURE_WIDGET",
      
      /**
       * @instance
       */
      postCreate: function alfresco_creation_WidgetConfig__postCreate() {
         this.alfSubscribe(this.configTopic, lang.hitch(this, "displayWidgetConfig"));
         this.alfSubscribe(this.clearTopic, lang.hitch(this, "clearCurrentDisplay"));
         this.alfSubscribe(this.saveTopic, lang.hitch(this, "saveWidgetConfig"));
      },
      
      /**
       * The configuration for the currently displayed widget.
       * 
       * @instance
       * @default
       */
      currentWidgetConfig: null,
      
      /**
       * Handler for the save button that published the updated configuration for a widget so
       * that it can be re-rendered.
       * 
       * @instance
       */
      saveWidgetConfig: function alfresco_creation_WidgetConfig__saveWidgetConfig() {
         if (this.currentWidgetConfig != null)
         {
            // Get the values for the current widgets...
            var updatedConfig = {};
            if (this.form == null)
            {
               this.alfLog("warn", "No form instance found to retrieve config data from", this);
            }
            else
            {
               updatedConfig = this.form.getValue();
            }
            
            this.alfPublish("ALF_UPDATE_RENDERED_WIDGET", {
               node: this.currentWidgetConfig.selectedNode,
               updatedConfig: updatedConfig,
               originalConfig: this.currentWidgetConfig.selectedItem
            });
            
            // Clear the display...
            this.clearCurrentDisplay();
         }
      },
      
      /**
       * Clears the currently displayed widget configuration.
       * 
       * @instance
       */
      clearCurrentDisplay: function alfresco_creation_WidgetConfig__clearCurrentDisplay() {
         var currentWidgets = registry.findWidgets(this.configNode);
         array.forEach(currentWidgets,  lang.hitch(this, "destroyOldConfigWidget"));
      },
      
      /**
       * This function is called whenever a new widget is selected that requires configuration.
       * 
       * @instance
       */
      displayWidgetConfig: function alfresco_creation_WidgetConfig__displayWidgetConfig(payload) {
         
         // Clear the previous widgets...
         this.clearCurrentDisplay();
         
         if (lang.exists("selectedItem.widgetsForConfig", payload))
         {
            // Save the current widget configuration...
            this.currentWidgetConfig = payload;
            
            // Create the controls for configuring the widget...
            // NOTE: Although it would make more sense for the form to have it's own scope, this would prevent
            //       it from receiving information about other form fields that have been dropped
            this.form = new Form({
               pubSubScope: this.pubSubScope,
               okButtonPublishTopic: this.saveTopic,
               okButtonLabel: this.message("saveConfig.button.label"),
               // okButtonPublishGlobal: true,
               cancelButtonPublishTopic: this.clearTopic,
               // cancelButtonPublishGlobal: true,
               widgets: payload.selectedItem.widgetsForConfig
            });
            this.form.placeAt(this.configNode);
         }
      },
      
      /**
       * 
       * @instance
       * @param {object[]} widgets The widgets that have been created.
       */
      allWidgetsProcessed: function alfresco_creation_WidgetConfig__allWidgetsProcessed(widgets) {
         this.alfLog("log", "Widget config processed");
      },
      
      /**
       * Simply calls destroyRecursive on the supplied widget, but abstracted to it's own function for
       * the purposes of extensibility.
       * 
       * @instance
       * @param {object} The widget to destroy
       * @param {number} The index of the widget in the config panel
       */
      destroyOldConfigWidget: function alfresco_creation_WidgetConfig__destroyOldConfigWidget(widget, index) {
         widget.destroyRecursive(false);
      }
      
   });
});