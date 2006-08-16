<%--
  Copyright (C) 2005 Alfresco, Inc.
 
  Licensed under the Mozilla Public License version 1.1 
  with a permitted attribution clause. You may obtain a
  copy of the License at
 
    http://www.alfresco.org/legal/license.txt
 
  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
  either express or implied. See the License for the specific
  language governing permissions and limitations under the
  License.
--%>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/alfresco.tld" prefix="a" %>
<%@ taglib uri="/WEB-INF/repo.tld" prefix="r" %>

<%@ page buffer="64kb" contentType="text/html;charset=UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="org.alfresco.web.ui.common.PanelGenerator" %>

<r:page titleId="title_space_details">

<f:view>
   
   <%-- load a bundle of properties with I18N strings --%>
   <f:loadBundle basename="alfresco.messages.webclient" var="msg"/>
   
   <h:form acceptCharset="UTF-8" id="space-details">
   
   <%-- Main outer table --%>
   <table cellspacing="0" cellpadding="2">
      
      <%-- Title bar --%>
      <tr>
         <td colspan="2">
            <%@ include file="../parts/titlebar.jsp" %>
         </td>
      </tr>
      
      <%-- Main area --%>
      <tr valign="top">
         <%-- Shelf --%>
         <td>
            <%@ include file="../parts/shelf.jsp" %>
         </td>
         
         <%-- Work Area --%>
         <td width="100%">
            <table cellspacing="0" cellpadding="0" width="100%">
               <%-- Breadcrumb --%>
               <%@ include file="../parts/breadcrumb.jsp" %>
               
               <%-- Status and Actions --%>
               <tr>
                  <td style="background-image: url(<%=request.getContextPath()%>/images/parts/statuspanel_4.gif)" width="4"></td>
                  <td bgcolor="#EEEEEE">
                  
                     <%-- Status and Actions inner contents table --%>
                     <%-- Generally this consists of an icon, textual summary and actions for the current object --%>
                     <table cellspacing="4" cellpadding="0" width="100%">
                        <tr>
                           <td width="32">
                              <img src="<%=request.getContextPath()%>/images/icons/details_large.gif" width=32 height=32>
                           </td>
                           <td>
                              <div class="mainTitle"><h:outputText value="#{msg.details_of}" /> '<h:outputText value="#{SpaceDetailsBean.name}" />'</div>
                              <div class="mainSubText"><h:outputText value="#{msg.location}" />: <r:nodePath value="#{SpaceDetailsBean.space.nodeRef}" breadcrumb="true" actionListener="#{BrowseBean.clickSpacePath}" /></div>
                              <div class="mainSubText"><h:outputText value="#{msg.spacedetails_description}" /></div>
                           </td>
                           
                           <%-- Navigation --%>
                           <td align="right">
                              <a:actionLink value="#{msg.previous_item}" image="/images/icons/nav_prev.gif" showLink="false" actionListener="#{SpaceDetailsBean.previousItem}" action="showSpaceDetails">
                                 <f:param name="id" value="#{SpaceDetailsBean.id}" />
                              </a:actionLink>
                              <img src="<%=request.getContextPath()%>/images/icons/nav_space.gif" width=24 height=24 align=absmiddle>
                              <a:actionLink value="#{msg.next_item}" image="/images/icons/nav_next.gif" showLink="false" actionListener="#{SpaceDetailsBean.nextItem}" action="showSpaceDetails">
                                 <f:param name="id" value="#{SpaceDetailsBean.id}" />
                              </a:actionLink>
                           </td>
                        </tr>
                     </table>
                  </td>
                  <td style="background-image: url(<%=request.getContextPath()%>/images/parts/statuspanel_6.gif)" width="4"></td>
               </tr>
               
               <%-- separator row with gradient shadow --%>
               <tr>
                  <td><img src="<%=request.getContextPath()%>/images/parts/statuspanel_7.gif" width="4" height="9"></td>
                  <td style="background-image: url(<%=request.getContextPath()%>/images/parts/statuspanel_8.gif)"></td>
                  <td><img src="<%=request.getContextPath()%>/images/parts/statuspanel_9.gif" width="4" height="9"></td>
               </tr>
               
               <%-- Details --%>
               <tr valign=top>
                  <td style="background-image: url(<%=request.getContextPath()%>/images/parts/whitepanel_4.gif)" width="4"></td>
                  <td>
                     <table cellspacing="0" cellpadding="3" border="0" width="100%">
                        <tr>
                           <td width="100%" valign="top">
                              <%-- wrapper comment used by the panel to add additional component facets --%>
                              <h:panelGroup id="dashboard-panel-facets">
                                 <f:facet name="title">
                                    <r:permissionEvaluator value="#{SpaceDetailsBean.space}" allow="Write" id="evalChange">
                                       <a:actionLink id="actModify" value="#{msg.modify}" action="dialog:applyTemplate" showLink="false" image="/images/icons/preview.gif" style="padding-right:8px" />
                                       <a:actionLink id="actRemove" value="#{msg.remove}" actionListener="#{SpaceDetailsBean.removeTemplate}" showLink="false" image="/images/icons/delete.gif" />
                                    </r:permissionEvaluator>
                                 </f:facet>
                              </h:panelGroup>
                              <a:panel label="#{msg.dashboard_view}" id="dashboard-panel" progressive="true" facetsId="dashboard-panel-facets"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE"
                                       expanded='#{SpaceDetailsBean.panels["dashboard-panel"]}' expandedActionListener="#{SpaceDetailsBean.expandPanel}">
                                 <table width=100% cellspacing=0 cellpadding=0 border=0>
                                    <tr>
                                       <td align=left>
                                          <r:permissionEvaluator value="#{SpaceDetailsBean.space}" allow="Write" id="evalApply">
                                             <a:actionLink id="actDashboard" value="#{msg.apply_dashboard}" rendered="#{SpaceDetailsBean.templatable == false}" action="dialog:applyTemplate" />
                                          </r:permissionEvaluator>
                                          <a:panel id="template-panel" rendered="#{SpaceDetailsBean.templatable == true}">
                                             <div style="padding:4px;border: 1px dashed #cccccc">
                                                <r:template id="dashboard" template="#{SpaceDetailsBean.templateRef}" model="#{SpaceDetailsBean.templateModel}" />
                                             </div>
                                          </a:panel>
                                       </td>
                                    </tr>
                                 </table>
                              </a:panel>
                              
                              <div style="padding:4px"></div>
                              
                              <a:panel label="#{msg.links}" id="links-panel" progressive="true"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE"
                                       expanded='#{SpaceDetailsBean.panels["links-panel"]}' expandedActionListener="#{SpaceDetailsBean.expandPanel}">
                                 <table width="100%" cellspacing="2" cellpadding="2" border="0" align="center">
                                    <tr>
                                       <td>
                                          <a:actionLink value="#{msg.view_in_webdav}" href="#{SpaceDetailsBean.webdavUrl}" target="new" id="link1" />
                                       </td>
                                       <td>
                                          <a:actionLink value="#{msg.view_in_cifs}" href="#{SpaceDetailsBean.cifsPath}" target="new" id="link2" />
                                       </td>
                                       <td>
                                          <a href='<%=request.getContextPath()%><a:outputText value="#{SpaceDetailsBean.bookmarkUrl}" id="out1" />' onclick="return false;"><a:outputText value="#{msg.details_page_bookmark}" id="out2" /></a>
                                       </td>
                                       <td>
                                          <a href='<a:outputText value="#{SpaceDetailsBean.nodeRefUrl}" id="out3" />' onclick="return false;"><a:outputText value="#{msg.noderef_link}" id="out4" /></a>
                                       </td>
                                    </tr>
                                 </table>
                              </a:panel>
                              
                              <div style="padding:4px"></div>
                              
                              <%-- wrapper comment used by the panel to add additional component facets --%>
                              <h:panelGroup id="props-panel-facets">
                                 <f:facet name="title">
                                    <r:permissionEvaluator value="#{SpaceDetailsBean.space}" allow="Write">
                                       <a:actionLink id="titleLink1" value="#{msg.modify}" showLink="false" image="/images/icons/Change_details.gif"
                                             action="dialog:editSpace" />
                                    </r:permissionEvaluator>
                                 </f:facet>
                              </h:panelGroup>
                              <a:panel label="#{msg.properties}" id="properties-panel" facetsId="props-panel-facets"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE" progressive="true"
                                       expanded='#{SpaceDetailsBean.panels["properties-panel"]}' expandedActionListener="#{SpaceDetailsBean.expandPanel}">
                                 <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                       <td width=80 align=center>
                                          <%-- icon image for the space --%>
                                          <table cellspacing=0 cellpadding=0 border=0>
                                             <tr>
                                                <td>
                                                   <div style="border: thin solid #CCCCCC; padding:4px">
                                                      <h:graphicImage id="space-logo" url="/images/icons/#{SpaceDetailsBean.space.properties.icon}.gif" width="32" height="32" />
                                                   </div>
                                                </td>
                                                <td><img src="<%=request.getContextPath()%>/images/parts/rightSideShadow42.gif" width=6 height=42></td>
                                             </tr>
                                             <tr>
                                                <td colspan=2><img src="<%=request.getContextPath()%>/images/parts/bottomShadow42.gif" width=48 height=5></td>
                                             </tr>
                                          </table>
                                       </td>
                                       <td>
                                          <%-- properties for the space --%>
                                          <r:propertySheetGrid id="space-props" value="#{SpaceDetailsBean.space}" var="spaceProps" 
                                                         columns="1" mode="view" labelStyleClass="propertiesLabel" 
                                                         externalConfig="true" />
                                          <h:messages globalOnly="true" styleClass="errorMessage" layout="table" />
                                          <h:message for="space-props" styleClass="statusMessage" />
                                       </td>
                                    </tr>
                                 </table>
                              </a:panel>
                              
                              <div style="padding:4px"></div>
                              
                              <h:panelGroup id="category-panel-facets">
                                 <f:facet name="title">
                                    <r:permissionEvaluator value="#{SpaceDetailsBean.space}" allow="Write">
                                       <a:actionLink id="titleLink3" value="#{msg.change_category}" showLink="false" image="/images/icons/Change_details.gif"
                                             action="editCategories" actionListener="#{SpaceDetailsBean.setupCategoriesForEdit}" />
                                    </r:permissionEvaluator>
                                 </f:facet>
                              </h:panelGroup>
                              <a:panel label="#{msg.category}" id="category-panel" facetsId="category-panel-facets" progressive="true"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE" rendered="#{SpaceDetailsBean.categorised}"
                                       expanded='#{SpaceDetailsBean.panels["category-panel"]}' expandedActionListener="#{SpaceDetailsBean.expandPanel}">
                                 <h:outputText id="category-overview" value="#{SpaceDetailsBean.categoriesOverviewHTML}" 
                                               escape="false" />
                              </a:panel>
                              <a:panel label="#{msg.category}" id="no-category-panel" progressive="true"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE"
                                       rendered="#{SpaceDetailsBean.categorised == false}"
                                       expanded='#{SpaceDetailsBean.panels["category-panel"]}' expandedActionListener="#{SpaceDetailsBean.expandPanel}">
                                 <h:outputText id="no-category-msg" value="#{msg.not_in_category_space}<br/><br/>" 
                                               escape="false"/>
                                 <r:permissionEvaluator value="#{SpaceDetailsBean.space}" allow="Write" id="eval_cat">
                                    <a:actionLink id="make-classifiable" value="#{msg.allow_categorization}" 
                                                  action="#{SpaceDetailsBean.applyClassifiable}"
                                                  rendered="#{SpaceDetailsBean.locked == false}" />
                                 </r:permissionEvaluator>
                              </a:panel>
                              
                              <div style="padding:4px"></div>
                              
                              <h:column id="rules-panel-facets">
                                 <f:facet name="title">
                                    <r:permissionEvaluator value="#{SpaceDetailsBean.space}" allow="Write">
                                       <a:actionLink id="titleLink2" value="#{msg.modify}" showLink="false" image="/images/icons/rule.gif" action="dialog:manageRules" />
                                    </r:permissionEvaluator>
                                 </f:facet>
                              </h:column>
                              <a:panel label="#{msg.rules}" id="rules-panel" facetsId="rules-panel-facets" progressive="true"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE"
                                       expanded='#{SpaceDetailsBean.panels["rules-panel"]}' expandedActionListener="#{SpaceDetailsBean.expandPanel}">
                                 <a:richList id="rulesList" viewMode="details" value="#{RulesBean.rules}" var="r"
                                          styleClass="recordSet" headerStyleClass="recordSetHeader" rowStyleClass="recordSetRow" 
                                          altRowStyleClass="recordSetRowAlt" width="100%" pageSize="10"
                                          initialSortColumn="title" initialSortDescending="true">
                                    
                                    <%-- Primary column for details view mode --%>
                                    <a:column id="col1" primary="true" width="200" style="padding:2px;text-align:left">
                                       <f:facet name="header">
                                          <a:sortLink label="#{msg.title}" value="title" mode="case-insensitive" styleClass="header"/>
                                       </f:facet>
                                       <h:outputText id="title" value="#{r.title}" />
                                    </a:column>
                                    
                                    <%-- Description columns --%>
                                    <a:column id="col2" style="text-align:left">
                                       <f:facet name="header">
                                          <a:sortLink label="#{msg.description}" value="description" styleClass="header"/>
                                       </f:facet>
                                       <h:outputText id="description" value="#{r.description}" />
                                    </a:column>
                                    
                                    <%-- Column to show whether the rule is local --%>
                                    <a:column style="text-align:left">
                                       <f:facet name="header">
                                          <a:sortLink label="#{msg.local}" value="local" styleClass="header"/>
                                       </f:facet>
                                       <h:outputText value="#{r.local}" >
                                          <a:convertBoolean/>
                                       </h:outputText>
                                    </a:column>
                                    
                                    <%-- Created Date column for details view mode --%>
                                    <a:column id="col3" style="text-align:left">
                                       <f:facet name="header">
                                          <a:sortLink label="#{msg.created_date}" value="createdDate" styleClass="header"/>
                                       </f:facet>
                                       <h:outputText id="createddate" value="#{r.createdDate}">
                                          <a:convertXMLDate type="both" pattern="#{msg.date_time_pattern}"/>
                                       </h:outputText>
                                    </a:column>
                                    
                                    <%-- Modified Date column for details/icons view modes --%>
                                    <a:column id="col4" style="text-align:left">
                                       <f:facet name="header">
                                          <a:sortLink label="#{msg.modified_date}" value="modifiedDate" styleClass="header"/>
                                       </f:facet>
                                       <h:outputText id="modifieddate" value="#{r.modifiedDate}">
                                          <a:convertXMLDate type="both" pattern="#{msg.date_time_pattern}" />
                                       </h:outputText>
                                    </a:column>
                                    
                                    <a:dataPager styleClass="pager" />
                                 </a:richList>
                              </a:panel>
                              
                              <div style="padding:4px"></div>
                              
                              <h:panelGroup id="rss-panel-facets">
                                 <f:facet name="title">
                                    <r:permissionEvaluator value="#{SpaceDetailsBean.space}" allow="Write" id="evalChange2">
                                       <a:actionLink id="actModify2" value="#{msg.modify}" action="dialog:applyRSSTemplate" showLink="false" image="/images/icons/rss.gif" style="padding-right:8px" />
                                       <a:actionLink id="actRemove2" value="#{msg.remove}" actionListener="#{SpaceDetailsBean.removeRSSTemplate}" showLink="false" image="/images/icons/delete.gif" />
                                    </r:permissionEvaluator>
                                 </f:facet>
                              </h:panelGroup>
                              <a:panel label="#{msg.rss_feed}" id="rss-panel" progressive="true" facetsId="rss-panel-facets"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE"
                                       expanded='#{SpaceDetailsBean.panels["rss-panel"]}' expandedActionListener="#{SpaceDetailsBean.expandPanel}">
                                 <table width=100% cellspacing=0 cellpadding=0 border=0>
                                    <tr>
                                       <td align=left>
                                          <r:permissionEvaluator value="#{SpaceDetailsBean.space}" allow="Write" id="evalApply2">
                                             <a:actionLink id="actApplyRSS" value="#{msg.apply_rss_feed}" rendered="#{SpaceDetailsBean.RSSFeed == false}" action="dialog:applyRSSTemplate" />
                                          </r:permissionEvaluator>
                                          <a:actionLink id="actRSS" value="#{msg.rss_feed_link}" href="#{SpaceDetailsBean.RSSFeedURL}" image="/images/icons/rss.gif" rendered="#{SpaceDetailsBean.RSSFeed == true}" padding="2" />
                                       </td>
                                    </tr>
                                 </table>
                              </a:panel>
                              
                              <%-- TODO: implement this - but READONLY details only! Manage Space Users for edits...
                                         need support for panel with facets - so can hide edit link unless edit permissions
                                         also need to wrap this panel with an permissions check: ReadPermissions
                              <a:panel label="#{msg.security}" id="security-panel" progressive="true" expanded="false"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE"
                                       action="manageInvitedUsers" linkTooltip="#{msg.manage_invited_users}" linkIcon="/images/icons/invite.gif">
                                 <table cellspacing="2" cellpadding="0" border="0" width="100%">
                                    
                                 </table>
                              </a:panel>
                              <div style="padding:4px"></div>
                              --%>
                              
                              <%-- TBD
                              <a:panel label="Preferences" id="preferences-panel" progressive="true" expanded="false"
                                       border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE">
                                 <div></div>
                              </a:panel>
                              --%>
                           </td>
                           
                           <td valign="top">
                              <% PanelGenerator.generatePanelStart(out, request.getContextPath(), "blue", "#D3E6FE"); %>
                              <table cellpadding="1" cellspacing="1" border="0" width="100%">
                                 <tr>
                                    <td align="center">
                                       <h:commandButton value="#{msg.close}" action="#{SpaceDetailsBean.closeDialog}" styleClass="wizardButton" />
                                    </td>
                                 </tr>
                              </table>
                              <% PanelGenerator.generatePanelEnd(out, request.getContextPath(), "blue"); %>
                              
                              <div style="padding:4px"></div>
                              
                              <%-- Space Actions --%>
                              <a:panel label="#{msg.actions}" id="actions-panel" border="white" bgcolor="white" titleBorder="blue" titleBgcolor="#D3E6FE" style="text-align:center" progressive="true"
                                    expanded='#{SpaceDetailsBean.panels["actions-panel"]}' expandedActionListener="#{SpaceDetailsBean.expandPanel}">
                                 <r:actions id="actions_space" value="space_details_actions" context="#{SpaceDetailsBean.space}" verticalSpacing="3" style="white-space:nowrap" />
                              </a:panel>
                           </td>
                        </tr>
                     </table>
                  </td>
                  <td style="background-image: url(<%=request.getContextPath()%>/images/parts/whitepanel_6.gif)" width="4"></td>
               </tr>
               
               <%-- separator row with bottom panel graphics --%>
               <tr>
                  <td><img src="<%=request.getContextPath()%>/images/parts/whitepanel_7.gif" width="4" height="4"></td>
                  <td width="100%" align="center" style="background-image: url(<%=request.getContextPath()%>/images/parts/whitepanel_8.gif)"></td>
                  <td><img src="<%=request.getContextPath()%>/images/parts/whitepanel_9.gif" width="4" height="4"></td>
               </tr>
               
            </table>
          </td>
       </tr>
    </table>
    
    </h:form>
    
</f:view>

</r:page>