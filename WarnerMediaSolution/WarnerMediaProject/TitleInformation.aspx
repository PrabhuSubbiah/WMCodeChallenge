<%@ Page Title="" Language="C#" MasterPageFile="~/WarnerMediaMaster.Master" AutoEventWireup="true" CodeBehind="TitleInformation.aspx.cs" Inherits="WarnerMediaProject.TitleInformation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="./JSLib/knockout-3.5.1.js"></script>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-modal/2.2.6/js/bootstrap-modal.min.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-modal/2.2.6/js/bootstrap-modalmanager.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-modal/2.2.6/css/bootstrap-modal.min.css" />   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="rows" style="padding-bottom:10px; border-bottom:solid">
            <label for="txtSearch">Search Title:</label>
            <input id="txtSearch" type="text" />
            <button id="butSearch" onclick="titleSearch(); return false;" class="bun bun-info">Search</button>
    </div>
    <div class="rows">
    <h1>Title List</h1>
    </div>
    <table id="TitleList" class="table table-striped">
        <thead>
          <tr>
            <th>Id</th>
            <th>Title Name</th>
            <th>Details</th>
          </tr>
        </thead>
        <tbody data-bind="foreach: titles">
          <tr>
            <td data-bind="text: titleId"></td>
            <td data-bind="text: titleName"></td>
            <td><button data-bind="click: showDetails" class="btn btn-primary">Show Details</button></td>
          </tr>
        </tbody>
      </table>
        <!-- Modal -->
        <div class="modal fade" id="titleDetailModal" tabindex="-1" role="dialog" aria-labelledby="titleDetailModalLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="titleDetailModalLabel">Title Information</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body" data-bind="using:detailTitleView">
                <div class="row" style="border-bottom:2px solid red">
                    <label for="titleName">TitleName:</label>
                    <span id="DetailTitleName" data-bind="text: titleName" />
                </div>
                <div class="row" style="border-bottom:2px solid block">
                <h4 style="padding:5px;border-bottom:solid;">Awards</h4>
                <table id="AwardList" class="table table-striped">
                    <thead>
                      <tr>
                        <th>Won</th>
                        <th>Year</th>
                        <th>Award</th>
                        <th>Company</th>
                      </tr>
                    </thead>
                    <tbody data-bind="foreach: titleAwards">
                      <tr>
                        <td data-bind="text: award"></td>
                        <td data-bind="text: awardyear"></td>
                        <td data-bind="text: awardwon"></td>
                        <td data-bind="text: awardcompany"></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="row" style="border-bottom:2px solid block">
                <h4 style="padding:5px;border-bottom:solid;">Story Line</h4>
                <table id="StoryLineList" class="table table-striped">
                    <thead>
                      <tr>
                        <th>Description</th>
                        <th>Language</th>
                      </tr>
                    </thead>
                    <tbody data-bind="foreach: storyLine">
                      <tr>
                        <td data-bind="text: storyDescription"></td>
                        <td data-bind="text: language"></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
    <script>
        function TitleInfo(id, tName) {
            self = this;
            self.titleId = id,
            self.titleName = ko.observable(tName);
            self.showDetails = function (title) {
                loadDetailViewModel(title);
                $('#titleDetailModal').modal('show');
            }
        }
        function loadDetailViewModel(title)
        {
            titlesVM.detailTitleView().titleName(title.titleName());
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: 'http://localhost:34657/WMTitleBusService.svc/GetStoryLine',
                data: '{"strSearch":"' + title.titleId + '"}',
                success: function (data) {
                    titlesVM.detailTitleView().storyLine.removeAll();
                    $($.parseJSON(data.d)).each(function (index, value) {
                        titlesVM.detailTitleView().storyLine.push(new storyLineVM(value.Description, value.Language));
                    });
                },
                error: function (result) {
                    alert(result);
                }
            });
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: 'http://localhost:34657/WMTitleBusService.svc/GetAwards',
                data: '{"strSearch":"' + title.titleId + '"}',
                success: function (data) {
                    titlesVM.detailTitleView().titleAwards.removeAll();
                    $($.parseJSON(data.d)).each(function (index, value) {
                        titlesVM.detailTitleView().titleAwards.push(new awards(value.awardwon, value.awardyear, value.award, value.awardcompany));
                    });
                },
                error: function (result) {
                    alert(result);
                }
            });
            

        }
        function storyLineVM(desc, lang) {
            self = this;
            this.storyDescription = ko.observable(desc);
            this.language = ko.observable(lang);
        }
        function awards(awardwon, awardyear, award,awardcompany)
        {
            self = this;
            this.awardwon = ko.observable(awardwon);
            this.awardyear = ko.observable(awardyear);
            this.award = ko.observable(award);
            this.awardcompany = ko.observable(awardcompany);
        }
        function TitleViewModel() {
            self = this;
            self.detailTitleView = ko.observable({
                titleName : ko.observable('Prabhu'),
                storyLine : ko.observableArray([]),
                titleAwards : ko.observableArray([])
        });
            self.titles = ko.observableArray([]);
        }
        var titlesVM = new TitleViewModel()
        $(function () {
            titleSearch();
            ko.applyBindings(titlesVM);
        });
        function titleSearch()
        {
            var tmp = $("#txtSearch").val();
            if (tmp == undefined)
                tmp = "";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: 'http://localhost:34657/WMTitleBusService.svc/GetData',
                data: '{"strSearch":"' + tmp + '"}',
                success: function (data) {
                    titlesVM.titles.removeAll();
                    $($.parseJSON(data.d)).each(function (index, value) {
                        titlesVM.titles.push(new TitleInfo(value.TitleId, value.TitleName));
                    });
                },
                error: function (result) {
                    alert(result);
                }
            });
            return false;
        }
    </script>
</asp:Content>
